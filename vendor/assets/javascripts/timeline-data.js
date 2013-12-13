"strict";

var timeline;
var data;
var baseApiUrl = 'http://0.0.0.0:3000/api/timelines/'

var debug = true

// Uncoment this for deployment
// $(window).resize(function () { 
//     timeline.render
// });


// Called whent the page is ready
$(document).ready(function() {

    // get data from the API to fill in the timeline
    // this calls drawVisualization() when it's done.
    getNewData();
  
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
  displayShite()
    var item = rowOfSelectedItem()
    if (item != undefined) { console.log("item " + item + " selected") }   
}

// function to delete a firework from the timeline
function onDelete(deleteID) {

  var item = rowOfSelectedItem();
  var itemToDelete = timeline.getData();
  var itemToDeleteID = deleteID || itemToDelete[item]['databaseID']
  deleteRecord(baseApiUrl + itemToDeleteID );
  
}

function addFireworkToTimeline(fireworkId, fireworkName) {
    var range = timeline.getVisibleChartRange();
    var start = new Date((range.start.valueOf() + range.end.valueOf()) / 2);


    var content = fireworkName
    // var content = "<a href='http://google.com'>link somewhere</a> " + fireworkName

    timeline.addItem({
        'start': start,
        'content': content,
        'editable' :true
    });
    var count = timeline.items.length;    
    var row = count-1
   
    timeline.setSelection([{
        'row': row
    }]);

    onChangeOrCreate();
}

function displayShite() {
  // var itemRow = rowOfSelectedItem();
  // var items = timeline.getData();
  // var item = items[itemRow]


  // $("#displayShite").html(
  //   '<p>selectedItemRow :' + JSON.stringify(itemRow, null, 4)  + '</p>'
  //   + '<p>item :' + JSON.stringify(item, null, 4) + '</p>'
  //   + '<p>All Items :' + JSON.stringify(items, null, 4) + '</p>'
  //   + '<p>Items count :' + items.length + '</p>'
    
  //   )
}

function onChangeOrCreate() { 
  displayShite()
  var item = rowOfSelectedItem();
  var itemToUpdate = timeline.getData();
  var itemToUpdateData = itemToUpdate[item]

  itemToUpdateData['show_id'] = getCurrentShowID()
  
  // this needs to be the real firework.
  itemToUpdateData['firework_id'] = 5
  itemToUpdateData['firework_id'] = 5
  saveRecord(baseApiUrl, itemToUpdateData ); 
}

function getCurrentShowID(){
  return $( "#mytimeline" ).data( 'show-id' )
}

function saveRecord(api_url, record) {
  // alert("save record called")
  displayShite()
  console.log("-------------------------------------------------")
  console.log(record)
  console.log("-------------------------------------------------")
  $.ajax({
        url: api_url ,
        type: "post",
        data:  record,
        success: function(response){
          // alert("database save")
          if (debug) {console.log("successful API POST")};


           record['id'] = response.id
           record['database_id'] = response.id


        },
        error:function(){
           if (debug) {console.log("failed API POST")};
        }
      });
}


function deleteRecord(api_url) {
  displayShite()
  $.ajax({
        url: api_url ,
        type: "delete",
        success: function(){
          if (debug) {console.log("successful API DELETE");};
        },
        error:function(){
          if (debug) {console.log("failed API DELETE");};
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
      if (debug) {console.log("successful API GET");};

      if (debug) {console.log("API data is : ")};
      if (debug) {console.log(apiData);};
     
      // convert the API data to timeline friendly format
      var timelineData = formatApiDataForTimeline(apiData)
      timelineData.push 

      configureStuff(timelineData) ;
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
  console.log(duration.duration)
  // specify options
  var options = {
      'width':  '100%',
      'height': '400px',
      'editable': true, 
      'style': 'box',
      'start' : new Date(2010, 0, 1 , 0, 0,0,0),
      "end": new Date(2010, 0, 1 , 0, 0, 0, duration.duration),
      "min": new Date(2010, 0, 1 , 0, 0,0,0),
      "max": new Date(2010, 0, 1 , 0, 0, 0, duration.duration),
      "zoomMin": 10,
      "zoomMax": duration.duration,
      "zoomable": true,
      "showMajorLabels": true,
      "animateZoom": true,
      "showCustomTime": true,
      'snapEvents' : true,
      'showButtonNew' : true
    };

    // Instantiate our timeline object.
    timeline = new links.Timeline(document.getElementById('mytimeline'));

     //listeners for timeline evernts
    links.events.addListener(timeline, 'select', onSelect );
    links.events.addListener(timeline, 'delete', onDelete );
    links.events.addListener(timeline, 'change', onChangeOrCreate );
    links.events.addListener(timeline, 'add', onChangeOrCreate );

 
    // Draw our timeline with the created data and options
    timeline.draw(dataVal, options);
}







