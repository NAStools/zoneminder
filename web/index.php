<?php
//
// ZoneMinder main web interface file, $Date$, $Revision$
// Copyright (C) 2001-2008 Philip Coombes
// 
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
// 

error_reporting( E_ALL );

$debug = false;
if ( $debug )
{
    // Use these for debugging, though not both at once!
    phpinfo( INFO_VARIABLES );
    //error_reporting( E_ALL );
}

// Use new style autoglobals where possible
if ( version_compare( phpversion(), "4.1.0", "<") )
{
    $_SESSION = &$HTTP_SESSION_VARS;
    $_SERVER = &$HTTP_SERVER_VARS;
}

// Useful debugging lines for mobile devices
if ( false )
{
    ob_start();
    phpinfo( INFO_VARIABLES );
    $fp = fopen( "/tmp/env.html", "w" );
    fwrite( $fp, ob_get_contents() );
    fclose( $fp );
    ob_end_clean();
}

require_once( 'includes/config.php' );
require_once( 'includes/logger.php' );
require_once( 'includes/Server.php' );
require_once( 'includes/Monitor.php' );

if ( isset($_SERVER["HTTPS"]) && $_SERVER["HTTPS"] == 'on' )
{
    $protocol = 'https';
}
else
{
    $protocol = 'http';
}
define( "ZM_BASE_PROTOCOL", $protocol );

// Absolute URL's are unnecessary and break compatibility with reverse proxies 
// define( "ZM_BASE_URL", $protocol.'://'.$_SERVER['HTTP_HOST'] );

// Use relative URL's instead
define( "ZM_BASE_URL", "" );

// Check time zone is set
if (!ini_get('date.timezone') || !date_default_timezone_set(ini_get('date.timezone'))) {
    date_default_timezone_set('UTC');
    Fatal( "ZoneMinder is not installed properly: php's date.timezone is not set to a valid timezone" );
}

if ( isset($_GET['skin']) )
    $skin = $_GET['skin'];
elseif ( isset($_COOKIE['zmSkin']) )
    $skin = $_COOKIE['zmSkin'];
elseif ( defined('ZM_SKIN_DEFAULT') )
	$skin = ZM_SKIN_DEFAULT;
else
    $skin = "classic";

$skins = array_map( 'basename', glob('skins/*',GLOB_ONLYDIR) );
if ( ! in_array( $skin, $skins ) ) {
	Error( "Invalid skin '$skin' setting to " . $skins[0] );
	$skin = $skins[0];
}

if ( isset($_GET['css']) )
	$css = $_GET['css'];
elseif ( isset($_COOKIE['zmCSS']) )
	$css = $_COOKIE['zmCSS'];
elseif (defined('ZM_CSS_DEFAULT'))
	$css = ZM_CSS_DEFAULT;
else
	$css = "classic";

$css_skins = array_map( 'basename', glob('skins/'.$skin.'/css/*',GLOB_ONLYDIR) );
if ( ! in_array( $css, $css_skins ) ) {
	Error( "Invalid skin css '$css' setting to " . $css_skins[0] );
	$css = $css_skins[0];
}

define( "ZM_BASE_PATH", dirname( $_SERVER['REQUEST_URI'] ) );
define( "ZM_SKIN_PATH", "skins/$skin" );

$skinBase = array(); // To allow for inheritance of skins
if ( !file_exists( ZM_SKIN_PATH ) )
    Fatal( "Invalid skin '$skin'" );
require_once( ZM_SKIN_PATH.'/includes/init.php' );
$skinBase[] = $skin;

ini_set( "session.name", "ZMSESSID" );

session_start();

if ( !isset($_SESSION['skin']) || isset($_REQUEST['skin']) || !isset($_COOKIE['zmSkin']) || $_COOKIE['zmSkin'] != $skin )
{
    $_SESSION['skin'] = $skin;
    setcookie( "zmSkin", $skin, time()+3600*24*30*12*10 );
}

if ( !isset($_SESSION['css']) || isset($_REQUEST['css']) || !isset($_COOKIE['zmCSS']) || $_COOKIE['zmCSS'] != $css ) {
	$_SESSION['css'] = $css;
	setcookie( "zmCSS", $css, time()+3600*24*30*12*10 );
}

if ( ZM_OPT_USE_AUTH )
    if ( isset( $_SESSION['user'] ) )
        $user = $_SESSION['user'];
    else
        unset( $user );
else
    $user = $defaultUser;

require_once( 'includes/lang.php' );
require_once( 'includes/functions.php' );

# Add Cross domain access headers
CORSHeaders();

// Check for valid content dirs
if ( !is_writable(ZM_DIR_EVENTS) || !is_writable(ZM_DIR_IMAGES) )
{
	Error( "Cannot write to content dirs('".ZM_DIR_EVENTS."','".ZM_DIR_IMAGES."').  Check that these exist and are owned by the web account user");
}

if ( isset($_REQUEST['view']) )
    $view = detaintPath($_REQUEST['view']);

if ( isset($_REQUEST['request']) )
    $request = detaintPath($_REQUEST['request']);

if ( isset($_REQUEST['action']) )
    $action = detaintPath($_REQUEST['action']);

foreach ( getSkinIncludes( 'skin.php' ) as $includeFile )
    require_once $includeFile;

require_once( 'includes/actions.php' );

# If I put this here, it protects all views and popups, but it has to go after actions.php because actions.php does the actual logging in.
if ( ZM_OPT_USE_AUTH && ! isset($user) && $view != 'login' ) {
    $view = 'login';
}

# Only one request can open the session file at a time, so let's close the session here to improve concurrency.
# Any file/page that uses the session must re-open it.
session_write_close();

if ( isset( $_REQUEST['request'] ) )
{
    foreach ( getSkinIncludes( 'ajax/'.$request.'.php', true, true ) as $includeFile )
    {
        if ( !file_exists( $includeFile ) )
            Fatal( "Request '$request' does not exist" );
        require_once $includeFile;
    }
    return;
}
else
{
    if ( $includeFiles = getSkinIncludes( 'views/'.$view.'.php', true, true ) )
    {
        foreach ( $includeFiles as $includeFile )
        {
            if ( !file_exists( $includeFile ) )
                Fatal( "View '$view' does not exist" );
            require_once $includeFile;
        }
		// If the view overrides $view to 'error', and the user is not logged in, then the
		// issue is probably resolvable by logging in, so provide the opportunity to do so.
		// The login view should handle redirecting to the correct location afterward.
		if ( $view == 'error' && !isset($user) )
		{
			$view = 'login';
			foreach ( getSkinIncludes( 'views/login.php', true, true ) as $includeFile )
				require_once $includeFile;
		}
    }
	// If the view is missing or the view still returned error with the user logged in,
	// then it is not recoverable.
    if ( !$includeFiles || $view == 'error' )
    {
        foreach ( getSkinIncludes( 'views/error.php', true, true ) as $includeFile )
            require_once $includeFile;
    }
}
?>
