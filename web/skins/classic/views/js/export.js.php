<?php
if ( isset($_REQUEST['eids']) )
{
    $eidParms = array();
    foreach ( $_REQUEST['eids'] as $eid )
        $eidParms[] = "eids[]=".validInt($eid);
?>
var eidParm = '<?php echo join( '&', $eidParms ) ?>';
<?php
}
else
{
?>
var eidParm = 'eid=<?php echo validInt($_REQUEST['eid']) ?>';
<?php
}
?>

var exportReady = <?php echo !empty($_REQUEST['generated'])?'true':'false' ?>;
var exportFile = '<?php echo !empty($_REQUEST['exportFile'])?validJsStr($_REQUEST['exportFile']):'' ?>';

var exportProgressString = '<?php echo addslashes(translate('Exporting')) ?>';
