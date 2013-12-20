"strict";

var timeline;
var data;
var baseApiUrl = 'http://' + window.location.host + '/api/timelines/';

var debug = true;

// Called whent the page is ready
$(document).ready(function() {

    // Get data from the API to fill in the timeline.
    // getNewData() calles configureWaveSurfer() and then drawVisualization()
    // when it has completed/

    getNewData();

    // detect key presses.
    $(document).keypress(function(keyPress) {
      var code = keyPress.keyCode || keyPress.which;
      if (code == 8) { 

        // do the API delete for the currently selected item 
        item = rowOfSelectedItem();
        if (item != undefined) {
          var objectToDelete = timeline.getData();
          var objectToDeleteID = objectToDelete[item]['databaseID']
          onDelete(objectToDeleteID)
          timeline.deleteItem(item);
        }
      }; 
    });
   
});


function configureWaveSurfer(timelineData){ 
 
  wavesurfer.on('ready', function () {

      firedFireworks = [];
      var duration = wavesurfer.backend.getDuration();
     
      drawVisualization(timelineData, {duration: duration * 1000});
      
      allFireworks = timeline.getData();

      wavesurfer.backend.on('audioprocess', function(progress) {
        var secs = Math.floor(progress)
        var ms = (progress - secs) * 1000
        var date = new Date(2010, 0, 1, 0, 0, secs, ms);
        timeline.setCustomTime(date);
        allFireworks.forEach(function(firework) {
          if (date >= firework.start - (1.6 * 1000) && $.inArray(firework, firedFireworks) == -1) {
            firedFireworks.push(firework);
            Fireworks.createParticle(null, null, null, getFireworkColourByID(firework.firework_id));
          }
          if (date < firework.start - (1.6 * 1000) && $.inArray(firework, firedFireworks) != -1) {
            firedFireworks.splice( $.inArray(firework, firedFireworks), 1 );
          }
        });
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

function displayShit(what) {
  $('#displayStuff').html('<p>'+ JSON.stringify(what, null, 4) + '</p>');
};

function onSelect() {
  var item = rowOfSelectedItem();
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

  timeline.addItem({
      'start': start,
      'content': fireworkName,
      'editable' :true
  });
  var count = timeline.items.length;    
  var row = count-1
 
 //set the selected state of the item we created.
  timeline.setSelection([{
      'row': row
  }]);

  // make sure the add gets saved to the DB
  onChangeOrCreate(fireworkId);
}


function onChangeOrCreate(fireworkId) { 

  var item = rowOfSelectedItem();
  var itemToUpdate = timeline.getData();
  var itemToUpdateData = itemToUpdate[item]

  itemToUpdateData['show_id'] = getCurrentShowID()
  
  // this needs to be the real firework.
  if (!itemToUpdateData['firework_id']) {
    itemToUpdateData['firework_id'] = fireworkId
  }


  allFireworks = timeline.getData();

  saveRecord(baseApiUrl, itemToUpdateData); 
}

function getCurrentShowID() {
  return $( "#mytimeline" ).data( 'show-id' )
}

function getFireworkColourByID(id) {
  return $('input[data-firework-id=' + id + ']').data('firework-colour');
}


function saveRecord(api_url, record) {
  // Javascript was being clever and trying to convert the date string
  // however it didn't include the milliseconds. 
  // This converts it to a string, which is good enough. 
  record.start = JSON.stringify(record.start, null, 4).replace(/"/g, '')

  $.ajax({
    url: api_url ,
    type: "post",
    data:  record,
    success: function(response){
      if (debug) {console.log("successful API POST")};   
     
      // set the id and database_id of our created object. 
      if (record['id'] == undefined) { record['id'] = response.id }
      if (record['database_id']) {record['database_id'] = response.id}
    },
    error:function(){
       if (debug) {console.log("failed API POST")};
    }
  });
}


function deleteRecord(api_url) {
  
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
    dataType: "json",
    success: function(apiData, status){
      if (debug) {console.log("successful API GET");};

      if (debug) {console.log("API data is : ")};
      if (debug) {console.log(apiData);};
     
      // convert the API data to timeline friendly format
      var timelineData = formatApiDataForTimeline(apiData)
      timelineData.push 

      configureWaveSurfer(timelineData) ;
    }        
  });
};



function formatApiDataForTimeline(jsonString) {
  // loop through the JSON string and convert 'start' and 'end' 
  // also add in databaseID
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

  // specify options
  var options = {
      'width':  '100%',
      'height': '140px',
      'editable': true, 
      'style': 'box',
      'start' : new Date(2010, 0, 1 , 0, 0,0,0),
      "end": new Date(2010, 0, 1 , 0, 0, 0, duration.duration),
      "min": new Date(2010, 0, 1 , 0, 0,0,0),
      "max": new Date(2010, 0, 1 , 0, 0, 0, duration.duration),
      "zoomMin": 10,
      "zoomMax": duration.duration,
      "zoomable": true,
      "showMajorLabels": false,
      "animateZoom": true,
      "showCustomTime": true,
      'snapEvents' : false,
      'showButtonNew' : false
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
