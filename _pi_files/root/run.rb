require 'pi_piper'
include PiPiper
Process.spawn('mpg321 /root/run.mp3')
ch1 = PiPiper::Pin.new(:pin => 7, :direction => :out)
ch2 = PiPiper::Pin.new(:pin => 8, :direction => :out)
ch3 = PiPiper::Pin.new(:pin => 25, :direction => :out)
ch4 = PiPiper::Pin.new(:pin => 24, :direction => :out)
ch5 = PiPiper::Pin.new(:pin => 23, :direction => :out)
ch6 = PiPiper::Pin.new(:pin => 11, :direction => :out)
ch7 = PiPiper::Pin.new(:pin => 17, :direction => :out)
ch8 = PiPiper::Pin.new(:pin => 22, :direction => :out)

sleep 9.687
ch1.on
sleep 0.553
ch1.off
ch2.on
sleep 0.514
ch2.off
ch3.on

sleep 1
pins = [ch1, ch2, ch3, ch4, ch5, ch6, ch7, ch8]
  pins.each do |pin|
  pin.off
end
