# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->

  updateProgress = (evt) ->
    if evt.lengthComputable
      percentComplete = (evt.loaded / evt.total)*100
      $('#progress_bar').progressbar("option", "value", percentComplete)
    
  $('#drop')[0].addEventListener 'drop', (e) ->
    file = e.dataTransfer.files[0]
    reader = new FileReader()
    wave = $('.controls')
    wave.css('visibility', 'visible')

    if file
      reader.readAsArrayBuffer(file)
      fd = new FormData()
      fd.append('key', 'tracks/' + file.name.replace(/\s+/g, ""));
      fd.append('AWSAccessKeyId', 'AKIAJD5FZFVKYPWHKUCA');
      fd.append('acl', 'private');
      fd.append('success_action_redirect', "http://example.com/upload_callback")
      fd.append('policy', window.policy)
      fd.append('signature', window.signature)
      fd.append('Content-Type', '$Content-Type')
      fd.append('file', file)

      xhr = new XMLHttpRequest()
      $("#progress_bar").progressbar()
      xhr.upload.onprogress=updateProgress
      xhr.open("POST", "https://fireworktracks.s3.amazonaws.com/", true)

      # creates a listener for when it is finished uploading then when it's uploaded does a post request
      xhr.upload.addEventListener 'load', (e) ->
        $.ajax
          type: "POST",
          url: "/tracks",
          data: { track_url: "https://s3.amazonaws.com/fireworktracks/tracks/" + file.name.replace(/\s+/g, "")},
          success: (status) ->
            console.log("Successs! FUCKING YEAH")

      xhr.send(fd)