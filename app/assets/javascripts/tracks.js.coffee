# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->

  updateProgress = (evt) ->
  	console.log('hi')
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
      fd.append('key', 'abc/' + file.name);
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
      xhr.onreadystatechange = (aEvt) ->
      	xhr.readyState is 4

      xhr.upload.addEventListener 'error', (e) ->
        console.log(e)

      xhr.send(fd)




  # reader.addEventListener('progress', function (e) {
  #     my.onProgress(e);
  # });
  # reader.addEventListener('load', function (e) {
  #     my.loadBuffer(e.target.result);
  # });
  # reader.addEventListener('error', function () {
  #     my.fireEvent('error', 'Error reading file');
  # });