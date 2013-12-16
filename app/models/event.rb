require 'Time'
class Event < ActiveRecord::Base
  belongs_to :firework

  def string_to_date string
    Time.parse(string)
  end

  def get_event_time
    base_time = string_to_date '2010-01-01T00:00:00.000Z'
    event_time = self.string_to_date self.start
    elapsed_time = (event_time - base_time) * 1000
  end

  
  
end
