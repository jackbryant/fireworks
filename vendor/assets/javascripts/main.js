'use strict';

// Create an instance
var wavesurfer = Object.create(WaveSurfer);

// Init & load audio file

function wsLoad() {
    var options = {
        container     : document.querySelector('#waveform'),
        waveColor     : 'navy',
        progressColor : '#910F15',
        loaderColor   : 'purple',
        cursorColor   : 'navy',
        markerWidth   : 2
    };

    if (location.search.match('scroll')) {
        options.minPxPerSec = 100;
        options.scrollParent = true;
    }

    if (location.search.match('normalize')) {
        options.normalize = true;
    }

    /* Progress bar */
    var progressDiv = document.querySelector('#progress-bar');
    var progressBar = progressDiv.querySelector('.progress-bar');
    wavesurfer.on('loading', function (percent, xhr) {
        $("#progress_bar_download").progressbar()
        $('#progress_bar_download .ui-progressbar-value').css('background', '#D6D6D6')
        $('#progress_bar_download').progressbar("option", "value", percent)
    });
    wavesurfer.on('ready', function () {
        $('#progress_bar_download').css('visibility', 'hidden')
        var controls = $('.controls')
        controls.css('visibility', 'visible')
    });

    // Init
    wavesurfer.init(options);
    // Load audio from URL

    if (track_url) { 
      wavesurfer.load(track_url);
      var dragndrop = $('#drop');
      dragndrop.css('visibility', 'hidden');
      var controls = $('.controls');
      controls.append('<button class="btn-btn-primary" id="change_song"><i class="glyphicon glyphicon-step-forward"></i>Change Song</button>');
    }

    // Start listening to drag'n'drop on document
    wavesurfer.bindDragNDrop('#drop');
}

document.addEventListener('DOMContentLoaded', wsLoad)

// Play at once when ready
// Won't work on iOS until you touch the page
wavesurfer.on('ready', function () {
    //wavesurfer.play();
});

// Bind buttons and keypresses
(function () {
    var eventHandlers = {
        'play': function () {
            if(!$('input:focus').length) {
                wavesurfer.playPause();
            }
        },

        'back': function () {
            wavesurfer.skipBackward();
        },

        'forth': function () {
            wavesurfer.skipForward();
        },
    };

    document.addEventListener('keydown', function (e) {
        var map = {
            32: 'play',       // space
            38: 'green-mark', // up
            40: 'red-mark',   // down
            37: 'back',       // left
            39: 'forth'       // right
        };
        if (e.keyCode in map) {
            var handler = eventHandlers[map[e.keyCode]];
            if(!$('input:focus').length) e.preventDefault();
            handler && handler(e);
        }
    });

    document.addEventListener('click', function (e) {
        var action = e.target.dataset && e.target.dataset.action;
        if (action && action in eventHandlers) {
            eventHandlers[action](e);
        }
    });
}());

// Flash mark when it's played over
wavesurfer.on('mark', function (marker) {
    if (marker.timer) { return; }

    marker.timer = setTimeout(function () {
        var origColor = marker.color;
        marker.update({ color: 'yellow' });

        setTimeout(function () {
            marker.update({ color: origColor });
            delete marker.timer;
        }, 100);
    }, 100);
});

wavesurfer.on('error', function (err) {
    console.error(err);
});
