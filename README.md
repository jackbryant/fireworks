#Launch.it

Welcome to Launch.it, a web application built to let you design professional standard firework shows to music. 

The system allows you to upload an audio track, synchronise firework launch times to particular points within the track and start the show from a safe distance using your laptop or phone. 

Built using 
 * Ruby on Rails,
 * Several Javascript libraries incluing Chaps-Links timeline, Wavesurfer.js
 * Pusher is used for messaging between the various components. 

The hardware consists of a Rasperry Pi running Ruby 2.0

Functionally, the project works as explained, however, we have not finished work on the front-end. If you wish to contribute to the project, clone the Github repo, run bundle install, rake db:create and rake db:migrate in the command line, work your magic then send us a pull request. 

You can find the application at [here](http://launchit.herokuapp.com).
