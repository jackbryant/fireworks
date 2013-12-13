"strict";

var timeline;
var data;
var baseApiUrl = 'http://0.0.0.0:3000/api/timelines/'

// Uncoment this for deployment
// $(window).resize(function () { 
//     timeline.render
// });


// Called whent the page is ready
$(document).ready(function() {
    //  gernerate policy and signiture for S3 upload.
    // In app/helpers/tracks_helper.rb
    // window.policy = '<%= policy %>'
    // window.signature = '<%= signature %>'


  

    // get data from the API to fill in the timeline
    // this calls drawVisualization() when it's done.
    timelineData = getNewData();

   

    //draw the timeline
    //  drawVisualization( timelineData );

      configureStuff(timelineData)

      //listeners for timeline evernts
      links.events.addListener(timeline, 'select', onSelect );
      links.events.addListener(timeline, 'delete', onDelete );
      links.events.addListener(timeline, 'change', onChangeOrCreate );
      links.events.addListener(timeline, 'add', onChangeOrCreate );

      links.events.addListener(timeline, 'ready', function() {
      allFireworks = timeline.getData();
      timeline.setVisibleChartRange(new Date(2010, 0, 1 , 0, 0,0,0), new Date(2010, 0, 1 , 0, 0, 0, duration.duration));
    });
  


    //event handlers
    
    $("#doStuff").click(function() {
      timeline.setVisibleChartRangeNow();
      // console.log(timeline.getVisibleChartRange())
    });

    $(document).keypress(function(keyPress) {
      var code = keyPress.keyCode || keyPress.which;
      if (code == 8) { 

        // do the API delete for the currently selected item 
        item = rowOfSelectedItem();
        if (item != undefined) {
          var objectToDelete = timeline.getData();
          var objectToDeleteID = objectToDelete[item]['databaseID']
          onDelete(objectToDeleteID)

          // do the timeline delete for the currently selected item
          var index = indexOfSelectedObject();
          timeline.deleteItem(index);
        }
      }; 
    });
   
});



function configureStuff(timelineData){
  wavesurfer.on('ready', function () {
      // wavesurfer.play();
      var duration = wavesurfer.backend.getDuration();
     
      drawVisualization(timelineData, {duration: duration * 1000});
        
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
}

function addFireworkToTimeline(fireworkId, fireworkName) {
            var range = timeline.getVisibleChartRange();
            var start = new Date((range.start.valueOf() + range.end.valueOf()) / 2);
            var content = fireworkName
            // var content = "<a href='http://google.com'>link somewhere</a> " + fireworkName

            timeline.addItem({
                'start': start,
                'content': content
            });

            console.log(timeline)
           
            var count = timeline.items.length;
             console.log(timeline.items.length)

            timeline.setSelection([{
                'row': count-1
            }]);

            /* !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

            Need to deal with the situation where a firework is 
            added to the timeline and then is moved. 

            This causes two entries to the database.
            Maybe just updating the view after this might do the trick. */

            onChangeOrCreate();
        }

function rowOfSelectedItem() {
   var timelineObject = timeline.getSelection();

   if (timelineObject.length) {
    if (timelineObject[0].row != undefined) {
      var row = timelineObject[0].row;  
      return row
    }
  }
}

function indexOfSelectedObject() {
  // returns the index of the selected item or nothing.
  for (var i = 0; i<timeline.items.length; i++) { 
   if (timeline.isSelected(i)) {
    return i
   }  
  };
}

function onSelect() {
    item = rowOfSelectedItem()
    if (item) { console.log("item " + item + " selected") }
    
}

// function to delete a firework from the timeline
function onDelete(deleteID) {
  item = rowOfSelectedItem();
  var itemToDelete = timeline.getData();
  var itemToDeleteID = deleteID || itemToDelete[item]['databaseID']
  deleteRecord(baseApiUrl + itemToDeleteID );
  console.log("item " + item + " deleted")
}

function onChangeOrCreate() { 
  item = rowOfSelectedItem();
  var itemToUpdate = timeline.getData();
  var itemToUpdateData = itemToUpdate[item]

  itemToUpdateData['show_id'] = getCurrentShowID()
  
  // this needs to be the real firework.
  itemToUpdateData['firework_id'] = 5

  // console.log(itemToUpdateData);
  saveRecord(baseApiUrl, itemToUpdateData ); 
  // console.log("item " + rowOfSelectedItem() + " changed")
}

function getCurrentShowID(){
  return $( "#mytimeline" ).data( 'show-id' )
}

function saveRecord(api_url, record) {
 
  $.ajax({
        url: api_url ,
        type: "post",
        data:  record,
        success: function(){
          console.log("successful API POST");
        },
        error:function(){
          console.log("failed API POST")
        }
      });
}

function deleteRecord(api_url) {
  $.ajax({
        url: api_url ,
        type: "delete",
        success: function(){
          console.log("successful API DELETE");
        },
        error:function(){
          console.log("failed API DELETE")
        }
      });
}


 function getNewData() {
  $.ajax({
    type: "GET",
    url: baseApiUrl+getCurrentShowID(),
    // url: 'http://0.0.0.0:3000/data',
    dataType: "json",
    success: function(apiData, status){
      console.log("successful API GET");


      console.log(apiData);
     
      // convert the API data to timeline friendly format
      var timelineData = formatApiDataForTimeline(apiData)
      timelineData.push 

      
      return timelineData;
    }        
  });
};



function formatApiDataForTimeline(jsonString) {
   // loop through the JSON string and convert 'start' and 'end' 
   var data = jsonString
      for (var key in data) {
        if (data.hasOwnProperty(key)) {
          data[key]["start"] = new Date( data[key]["start"] );
          
          
          if (data[key]["end"]) {
          data[key]["end"] = new Date ( data[key]["end"] );
          }
          data[key]["databaseID"] =  data[key]["id"] ;
        }
      }

      return jsonString
};


// Called when the Visualization API is loaded.
function drawVisualization(dataVal, duration) {
    // Create a JSON data table

    data = dataVal;
   
    // specify options
  var options = {
      'width':  '100%',
      'height': '200px',
      'editable': true, 
      'style': 'box',
      // "min": new Date(2010, 0, 1 , 0, 0,0,0),
      // "max": new Date(2010, 0, 1 , 0, 0, 0, duration.duration),
      // "zoomMin": 10,
      // "zoomMax": 1000 * 60 * 60,
      "zoomable": true,
      "showMajorLabels": false,
      "animateZoom": true,
      "showCustomTime": true,
      'snapEvents' : false
    };

    // Instantiate our timeline object.
    timeline = new links.Timeline(document.getElementById('mytimeline'));


    // Draw our timeline with the created data and options
    timeline.draw(data, options);
}







