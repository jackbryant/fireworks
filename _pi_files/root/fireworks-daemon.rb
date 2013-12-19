#!/usr/bin/env ruby
require 'pi_piper'
include PiPiper
require 'pusher'
require 'pusher-client'
require 'macaddr'

def new_led_pin
  led_pin = PiPiper::Pin.new(:pin => 9, :direction => :out)
  led_pin.off 
  led_pin
end

def download_timings url
  system "curl #{url} > /root/run.rb"
end

def dowload_mp3 url
   system "curl #{url} > /root/run.mp3"
end

def on_failure
  led_pin = new_led_pin
  puts "led_pin #{led_pin}" 
  led_pin.on
  sleep 4
  led_pin.off  
end 

def flash_pin num
  led_pin = new_led_pin
  num.times do
    led_pin.on
    sleep 0.2
    led_pin.off 
    sleep 0.2
  end
end

def count_down
   flash_pin 3
   sleep 0.5
   flash_pin 2
   sleep 0.5
   flash_pin 1
 end

def fire_show
  count_down
  Process.spawn('ruby /root/run.rb',  [:out, :err]=>["log-fw", "w"]) 
end

Pusher.app_id = '61655'
Pusher.key = '26f4232b489d7c8a2e22'
Pusher.secret = 'da6df554f835d0121657'

options = {:secret => 'da6df554f835d0121657'} 
socket = PusherClient::Socket.new('26f4232b489d7c8a2e22', options)

socket.connect(true)

Thread.new { socket.subscribe('presence-of-boards', :user_id => 10, :user_info => { :mac => "#{Mac.addr}" }) }

# Channel name : test_channel
# Event name : new_message
# Event data : { "timing_url": "http://192.168.50.151:3000/shows/3/download", "mp3_url": "http://192.168.50.151:3000/assets/run.mp3" }

socket['test_channel'].bind('new_message') do |data|
  data_as_hash = JSON.parse(data)

  if  data_as_hash['fire'] == 'true'
    fire_show
  else
    
    timings_url = data_as_hash['timing_url']
    mp3_url = data_as_hash['mp3_url']
    board_id = data_as_hash['board_id']
    # puts "Mac.addr #{Mac.addr}"
    # puts "board_id #{board_id}"
    if(Mac.addr == board_id)
      
      download_timings timings_url if timings_url
      dowload_mp3 mp3_url if mp3_url
      flash_pin 2
    end
  end


end

after :pin => 18, :goes => :high do
  count_down
  Process.spawn('ruby /root/run.rb',  [:out, :err]=>["log-fw", "w"]) 
end

PiPiper.wait
# loop do
#   sleep(1) # Keep your main thread running
  
# end
