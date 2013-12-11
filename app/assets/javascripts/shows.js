function drawVisualization(dataVal, duration) {

  var data = [
  {
    'start': new Date(2010,0,1,0,1),
    'content': 'Firework',
    'customProps': { 'fired': false, 'num': 1, 'colour': 100 }
  },
  {
    'start': new Date(2010,0,1,0,1, 10),
    'content': 'Firework 2',
    'customProps': { 'fired': false, 'num': 2, 'colour': 800 }
  }
  ]

  var options = {
    'width':  '100%',
    'height': '200px',
    'editable': true, 
    'style': 'box',
    "min": new Date(2010, 0, 1 , 0, 0,0,0),
    "max": new Date(2010, 0, 1 , 0, 0, 0, duration.duration),
    "zoomMin": 10,
    "zoomMax": 1000 * 60 * 60,
    "zoomable": true,
    "showMajorLabels": false,
    "animateZoom": true,
    "showCustomTime": true
  };

  timeline = new links.Timeline(document.getElementById('mytimeline'));
  links.events.addListener(timeline, 'ready', function() {
    allFireworks = timeline.getData();
    timeline.setVisibleChartRange(new Date(2010, 0, 1 , 0, 0,0,0), new Date(2010, 0, 1 , 0, 0, 0, duration.duration));
   });

  timeline.draw(data, options);
}

var timeline;
$(function() {

  wavesurfer.on('ready', function () {
    wavesurfer.play();
    var duration = wavesurfer.backend.getDuration();
    drawVisualization([], {duration: duration * 1000});
      
    wavesurfer.backend.on('audioprocess', function(progress) {
      var secs = Math.floor(progress)
      var ms = (progress - secs) * 1000
      var date = new Date(2010, 0, 1, 0, 0, secs, ms);
      timeline.setCustomTime(date);
    });

    links.events.addListener(timeline, 'timechange', function (time) {
        var timeline_minutes_in_msecs = time.time.getMinutes() * 60 * 1000
        var timeline_seconds_in_msecs = time.time.getSeconds() * 1000
        var timeline_milliseconds_in_msecs = time.time.getMilliseconds()
        var timeline_total_time_in_msecs = timeline_minutes_in_msecs + timeline_seconds_in_msecs + timeline_milliseconds_in_msecs
        
        wavesurfer.seekTo(timeline_total_time_in_msecs / (wavesurfer.backend.getDuration() * 1000));
        
        
    });
  });


  // $(document).on('mousedown', function(e) {
  //   wavesurfer.pause();
  // })

});