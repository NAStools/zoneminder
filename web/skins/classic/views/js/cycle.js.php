var currGroup = "<?php echo isset($_REQUEST['group'])?validJsStr($_REQUEST['group']):'' ?>";
var nextMid = "<?php echo isset($nextMid)?$nextMid:'' ?>";
var mode = "<?php echo $mode ?>";

var cycleRefreshTimeout = <?php echo 1000*ZM_WEB_REFRESH_CYCLE ?>;
