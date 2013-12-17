#!/usr/bin/env ruby
require 'pi_piper'
include PiPiper

led_pin = PiPiper::Pin.new(:pin => 9, :direction => :out)

led_pin.off 
led_pin_status = false

after :pin => 18, :goes => :high do
  
  if led_pin_status 
    led_pin.off
    led_pin_status = false
  else 
    led_pin.on
    led_pin_status = true
    Process.spawn('ruby /root/run.rb',  [:out, :err]=>["log-fw", "w"]) 
  end
end

PiPiper.wait