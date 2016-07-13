<?php
//
// ZoneMinder web function view file, $Date$, $Revision$
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

if ( !canEdit( 'Monitors' ) )
{
    $view = "error";
    return;
}

$monitor = dbFetchMonitor( $_REQUEST['mid'] );

$focusWindow = true;

xhtmlHeaders(__FILE__, translate('Function')." - ".validHtmlStr($monitor['Name']) );
?>
<body>
  <div id="page">
    <div id="header">
      <h2><?php echo translate('Function')." - ".validHtmlStr($monitor['Name']) ?></h2>
    </div>
    <div id="content">
      <form name="contentForm" id="contentForm" method="post" action="<?php echo $_SERVER['PHP_SELF'] ?>">
        <input type="hidden" name="view" value="none"/>
        <input type="hidden" name="action" value="function"/>
        <input type="hidden" name="mid" value="<?php echo $monitor['Id'] ?>"/>
        <p>
          <select name="newFunction">
<?php
foreach ( getEnumValues( 'Monitors', 'Function' ) as $optFunction )
{
?>
            <option value="<?php echo $optFunction ?>"<?php if ( $optFunction == $monitor['Function'] ) { ?> selected="selected"<?php } ?>><?php echo translate('Fn'.$optFunction) ?></option>
<?php
}
?>
          </select>
          <label for="newEnabled"><?php echo translate('Enabled') ?></label><input type="checkbox" name="newEnabled" id="newEnabled" value="1"<?php if ( !empty($monitor['Enabled']) ) { ?> checked="checked"<?php } ?>/>
        </p>
        <div id="contentButtons">
          <input type="submit" value="<?php echo translate('Save') ?>"/>
          <input type="button" value="<?php echo translate('Cancel') ?>" onclick="closeWindow()"/>
        </div>
      </form>
    </div>
  </div>
</body>
</html>
