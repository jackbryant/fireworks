class Show < ActiveRecord::Base
   has_many :events

  def get_events_from_show 
    self.events.order("start asc")
  end

  def get_relative_timings events
    current_time = 0
    times = events.map do |event_time|  
        my_time, current_time = event_time - current_time , event_time
        my_time
    end
  end

  def remove_delays events, delays
    events.each_with_index.map do |event_time, index | 
      event_time - delays[index] 
    end
  end

  def create_firing_string timings
    string = "require 'pi_piper'\n"
    string << "include PiPiper\n" \
              "Process.spawn('mpg321 /root/run.mp3')\n" \
              "ch1 = PiPiper::Pin.new(:pin => 7, :direction => :out)\n" \
              "ch2 = PiPiper::Pin.new(:pin => 8, :direction => :out)\n" \
              "ch3 = PiPiper::Pin.new(:pin => 25, :direction => :out)\n" \
              "ch4 = PiPiper::Pin.new(:pin => 24, :direction => :out)\n" \
              "ch5 = PiPiper::Pin.new(:pin => 23, :direction => :out)\n" \
              "ch6 = PiPiper::Pin.new(:pin => 11, :direction => :out)\n" \
              "ch7 = PiPiper::Pin.new(:pin => 17, :direction => :out)\n" \
              "ch8 = PiPiper::Pin.new(:pin => 22, :direction => :out)\n\n"

    timings.each_with_index do |fire_time, index|
      channel = index + 1
      previous = channel - 1
      fire_time = fire_time / 1000.0
      string << "sleep #{fire_time}\n"
       string << "ch#{(previous)}.off\n" if index > 0 
      string << "ch#{channel}.on\n"  
    end
    string << "\nsleep 1\n" \
              "pins = [ch1, ch2, ch3, ch4, ch5, ch6, ch7, ch8]\n" \
              "  pins.each do |pin|\n" \
              "  pin.off\n" \
              "end\n" \
  end

  def construct_timings_file  
  
    event_timings = self.get_event_timings 
    delays = self.get_event_delays

    relative_timings = self.get_relative_timings event_timings
    relative_timings_without_delays = self.remove_delays relative_timings, delays

    create_firing_string relative_timings_without_delays
  end

  def get_event_timings 
   
     events =  self.get_events_from_show 
     events.map {|event| event.get_start_time_from_base}
  end

   def get_event_delays 

     events =  self.get_events_from_show 
     events.map {|delay| delay.get_delay_time}
  end

end


