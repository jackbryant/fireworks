class Show < ActiveRecord::Base
   has_many :events

  def get_events_from_show show_id
    show = Show.find(show_id)
    events = show.events
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

# def create_firing_string timings
#   string = "require 'whatever'\n"
#   timings.each_with_index do |fire_time, index|
#     string << "sleep #{fire_time}\n"
#     string << "pin(#{index}) high\n"  
#   end
#   string
# end


# delays = [23, 0, 100]
# events = [5000, 6000, 8000]
# events = remove_delays events, delays
# timings = create_timings events
# firing_string = create_firing_string timings
# puts firing_string

end


