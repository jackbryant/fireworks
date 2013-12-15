# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->

  `reader = new FileReader();`

  reader.addEventListener 'load', (e) ->
    wavesurfer.loadBuffer e.target.result

  updateProgress = (evt) ->
    if evt.lengthComputable
      percentComplete = (evt.loaded / evt.total)*100
      $('#progress_bar_upload').progressbar("option", "value", percentComplete)
      if percentComplete > 99.9
        $('#progress_bar_upload .ui-progressbar-value').css('background', 'green')

    
  $('#drop')[0].addEventListener 'drop', (e) ->
    file = e.dataTransfer.files[0]
    controls = $('.controls')
    controls.css('visibility', 'visible')

    if file
      $("#progress_bar_upload").progressbar()
      $("#progress_bar_download").progressbar()
      $('#progress_bar_download').remove()
      $('#progress_bar_upload .ui-progressbar-value').css('background', 'orange')
      reader.readAsArrayBuffer(file)
      date = Date.now()
      file_name = file.name.replace(/\s+/g, "")
      file_extension = file_name.slice(-4)
      file_name_with_date = file_name.slice(0, -4) + date
      unique_file_name = file_name_with_date + file_extension
      fd = new FormData()
      fd.append('key', 'tracks/' + unique_file_name);
      fd.append('AWSAccessKeyId', 'AKIAJD5FZFVKYPWHKUCA');
      fd.append('acl', 'private');
      fd.append('success_action_redirect', "http://example.com/upload_callback")
      fd.append('policy', window.policy)
      fd.append('signature', window.signature)
      fd.append('Content-Type', '$Content-Type')
      fd.append('file', file)

      xhr = new XMLHttpRequest()
      $("#progress_bar_upload").progressbar()
      xhr.upload.onprogress=updateProgress
      xhr.open("POST", "https://fireworktracks.s3.amazonaws.com/", true)

      # creates a listener for when it is finished uploading then when it's uploaded does a post request
      xhr.upload.addEventListener 'load', (e) ->
        $.ajax
          type: "POST",
          url: "/tracks",
          data: { track_url: "https://s3.amazonaws.com/fireworktracks/tracks/" + unique_file_name, show_id: getCurrentShowID() },
          success: (status) ->
            console.log("Successs!")

      xhr.send(fd)

