Viewing Events
==============

From the monitor or filtered events listing you can now click on an event to view it in more detail. 

This is an example view that shows events for a specific monitor:

.. image:: images/viewevents-main.png


If you have streaming capability you will see a series of images that make up the event. Under that you should also see a progress bar. Depending on your configuration this will either be static or will be filled in to indicate how far through the event you are. By default this functionality is turned off for low bandwidth settings as the image delivery tends to not be able to keep up with real-time and the progress bar cannot take this into account. Regardless of whether the progress bar updates, you can click on it to navigate to particular points in the events.

You will also see a link to allow you to view the still images themselves. If you don't have streaming then you will be taken directly to this page. The images themselves are thumbnail size and depending on the configuration and bandwidth you have chosen will either be the full images scaled in your browser of actual scaled images. If it is the latter, if you have low bandwidth for example, it may take a few seconds to generate the images. If thumbnail images are required to be generated, they will be kept and not re-generated in future. Once the images appear you can mouse over them to get the image sequence number and the image score.

Here is an example of viewing an event stream:

.. image:: images/viewevents-stream.png
	:width: 650px

* **A**: Administrative Event options on the event including viewing individual frames
* **B**: The actual image stream
* **C**: Navigation control
* **D**: You can switch between watching a single event or Continuous mode (where it advances to the next event after playback is complete)
* **E**: Event progress bar - how much of the current event has been played back

You will notice for the first time that alarm images now contain an overlay outlining the blobs that represent the alarmed area. This outline is in the colour defined for that zone and lets you see what it was that caused the alarm. Clicking on one of the thumbnails will take you to a full size window where you can see the image in all its detail and scroll through the various images that make up the event. If you have the ZM_RECORD_EVENT_STATS option on, you will be able to click the 'Stats' link here and get some analysis of the cause of the event. 

More details on the Administrative Event options (A)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Should you determine that you don't wish to keep the event, clicking on Delete will erase it from the database and file system. Returning to the event window, other options here are renaming the event to something more meaningful, refreshing the window to replay the event stream, deleting the event, switching between streamed and still versions of the event (if supported) and generating an MPEG video of the event (if supported).

These last two options require further explanation. Archiving an event means that it is kept to one side and not displayed in the normal event listings unless you specifically ask to view the archived events. This is useful for keeping events that you think may be important or just wish to protect. Once an event is archived it can be deleted or unarchived but you cannot accidentally delete it when viewing normal unarchived events.

The final option of generating an MPEG video is still somewhat experimental and its usefulness may vary. It uses the open source ffmpeg encoder to generate short videos, which will be downloaded to your browsing machine or viewed in place. When using the ffmpeg encoder, ZoneMinder will attempt to match the duration of the video with the duration of the event. Ffmpeg has a particularly rich set of options and you can specify during configuration which additional options you may wish to include to suit your preferences. In particular you may need to specify additional, or different, options if you are creating videos of events with particularly slow frame rates as some codecs only support certain ranges of frame rates. A common value for FFMPEG_OUTPUT_OPTIONS under Options > Images might be ``'-r 25 -b 800k'`` for 25 fps and 800 kbps.  Details of these options can be found in the `documentation <http://ffmpeg.org/ffmpeg-doc.html>`__ for the encoders and is outside the scope of this document.

Building an MPEG video, especially for a large event, can take some time and should not be undertaken lightly as the effect on your host box of many CPU intensive encoders will not be good. However once a video has been created for an event it will be kept so subsequent viewing will not incur the generation overhead. Videos can also be included in notification emails, however care should be taken when using this option as for many frequent events the penalty in CPU and disk space can quickly mount up.
