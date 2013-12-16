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
    string = "require 'whatever'\n"
    string << "# play the audio\n"
    timings.each_with_index do |fire_time, index|
      string << "sleep #{fire_time}\n"
      string << "pin(#{index}) high\n"  
    end
    string
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


