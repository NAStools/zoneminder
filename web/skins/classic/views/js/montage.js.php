//
// Import constants
//
var STATE_IDLE = <?php echo STATE_IDLE ?>;
var STATE_PREALARM = <?php echo STATE_PREALARM ?>;
var STATE_ALARM = <?php echo STATE_ALARM ?>;
var STATE_ALERT = <?php echo STATE_ALERT ?>;
var STATE_TAPE = <?php echo STATE_TAPE ?>;

var stateStrings = new Array();
stateStrings[STATE_IDLE] = "<?php echo translate('Idle') ?>";
stateStrings[STATE_PREALARM] = "<?php echo translate('Idle') ?>";
stateStrings[STATE_ALARM] = "<?php echo translate('Alarm') ?>";
stateStrings[STATE_ALERT] = "<?php echo translate('Alert') ?>";
stateStrings[STATE_TAPE] = "<?php echo translate('Record') ?>";

var CMD_QUERY = <?php echo CMD_QUERY ?>;

var SCALE_BASE = <?php echo SCALE_BASE ?>;

var COMPACT_MONTAGE = <?php echo ZM_WEB_COMPACT_MONTAGE ?>;
var SOUND_ON_ALARM = <?php echo ZM_WEB_SOUND_ON_ALARM ?>;
var POPUP_ON_ALARM = <?php echo ZM_WEB_POPUP_ON_ALARM ?>;

var statusRefreshTimeout = <?php echo 1000*ZM_WEB_REFRESH_STATUS ?>;

var canStreamNative = <?php echo canStreamNative()?'true':'false' ?>;

var monitorData = new Array();
<?php
foreach ( $monitors as $monitor )
{
?>
monitorData[monitorData.length] = { 
	'id': <?php echo $monitor->Id() ?>, 
	'connKey': <?php echo $monitor->connKey() ?>, 
	'width': <?php echo $monitor->Width() ?>,
	'height':<?php echo $monitor->Height() ?>,
  'server_url': '<?php echo $monitor->Server()->Url().$_SERVER['PHP_SELF'] ?>'
};
<?php
}
?>
