# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('#drop')[0].addEventListener 'drop', (e) ->
    file = e.dataTransfer.files[0]
    reader = new FileReader()
    wave = $('.controls')
    wave.css('visibility', 'visible')

  # reader.addEventListener('progress', function (e) {
  #     my.onProgress(e);
  # });
  # reader.addEventListener('load', function (e) {
  #     my.loadBuffer(e.target.result);
  # });
  # reader.addEventListener('error', function () {
  #     my.fireEvent('error', 'Error reading file');
  # });

    if file
      reader.readAsArrayBuffer(file);
      fd = new FormData();
      fd.append("fileToUpload", file);
      xhr = new XMLHttpRequest();
      xhr.open("POST", "/tracks");
      xhr.send(fd);