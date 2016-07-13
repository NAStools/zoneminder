<?php
//
// ZoneMinder web user view file, $Date$, $Revision$
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

if ( !canEdit( 'System' ) )
{
    $view = "error";
    return;
}

if ( $_REQUEST['id'] ) {
	if ( !($newServer = dbFetchOne( 'SELECT * FROM Servers WHERE Id = ?', NULL, ARRAY($_REQUEST['id'])) ) ) {
		$view = "error";
		return;
	}
} else {
	$newServer = array();
	$newServer['Name'] = translate('NewServer');
	$newServer['Hostname'] = '';
}

$focusWindow = true;

xhtmlHeaders(__FILE__, translate('Server')." - ".$newServer['Name'] );
?>
<body>
  <div id="page">
    <div id="header">
      <h2><?php echo translate('Server')." - ".$newServer['Name'] ?></h2>
    </div>
    <div id="content">
      <form name="contentForm" method="post" action="<?php echo $_SERVER['PHP_SELF'] ?>" onsubmit="return validateForm( this, <?php echo empty($newServer['Name'])?'true':'false' ?> )">
        <input type="hidden" name="view" value="<?php echo $view ?>"/>
        <input type="hidden" name="object" value="server"/>
        <input type="hidden" name="id" value="<?php echo validHtmlStr($_REQUEST['id']) ?>"/>
        <table id="contentTable" class="major" cellspacing="0">
          <tbody>
            <tr>
              <th scope="row"><?php echo translate('Name') ?></th>
              <td><input type="text" name="newServer[Name]" value="<?php echo $newServer['Name'] ?>"/></td>
            </tr>
            <tr>
              <th scope="row"><?php echo translate('Hostname') ?></th>
              <td><input type="text" name="newServer[Hostname]" value="<?php echo $newServer['Hostname'] ?>"/></td>
            </tr>
          </tbody>
        </table>
        <div id="contentButtons">
		<input type="hidden" name="action" value="Save"/>
          <input type="submit" value="<?php echo translate('Save') ?>"/>
          <input type="button" value="<?php echo translate('Cancel') ?>" onclick="closeWindow();"/>
        </div>
      </form>
    </div>
  </div>
</body>
</html>
