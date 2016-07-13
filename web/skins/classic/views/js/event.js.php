//
// Import constants
//
var CMD_NONE = <?php echo CMD_NONE ?>;
var CMD_PAUSE = <?php echo CMD_PAUSE ?>;
var CMD_PLAY = <?php echo CMD_PLAY ?>;
var CMD_STOP = <?php echo CMD_STOP ?>;
var CMD_FASTFWD = <?php echo CMD_FASTFWD ?>;
var CMD_SLOWFWD = <?php echo CMD_SLOWFWD ?>;
var CMD_SLOWREV = <?php echo CMD_SLOWREV ?>;
var CMD_FASTREV = <?php echo CMD_FASTREV ?>;
var CMD_ZOOMIN = <?php echo CMD_ZOOMIN ?>;
var CMD_ZOOMOUT = <?php echo CMD_ZOOMOUT ?>;
var CMD_PAN = <?php echo CMD_PAN ?>;
var CMD_SCALE = <?php echo CMD_SCALE ?>;
var CMD_PREV = <?php echo CMD_PREV ?>;
var CMD_NEXT = <?php echo CMD_NEXT ?>;
var CMD_SEEK = <?php echo CMD_SEEK ?>;
var CMD_QUERY = <?php echo CMD_QUERY ?>;

var SCALE_BASE = <?php echo SCALE_BASE ?>;

//
// PHP variables to JS
//
var connKey = '<?php echo $connkey ?>';

var eventData = {
    Id: <?php echo $event['Id'] ?>,
    Width: <?php echo $event['Width'] ?>,
    Height: <?php echo $event['Height'] ?>,
    Length: <?php echo $event['Length'] ?>
};

var filterQuery = '<?php echo isset($filterQuery)?validJsStr($filterQuery):'' ?>';
var sortQuery = '<?php echo isset($sortQuery)?validJsStr($sortQuery):'' ?>';

var scale = <?php echo $scale ?>;
var canEditEvents = <?php echo canEdit( 'Events' )?'true':'false' ?>;
var streamTimeout = <?php echo 1000*ZM_WEB_REFRESH_STATUS ?>;

var canStreamNative = <?php echo canStreamNative()?'true':'false' ?>;

//
// Strings
//
var deleteString = "<?php echo translate('Delete') ?>";
var causeString = "<?php echo translate('AttrCause') ?>";
