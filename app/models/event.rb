require 'Time'
class Event < ActiveRecord::Base
  belongs_to :firework

  def string_to_date string
    Time.parse(string)
  end

  def get_start_time_from_base
    base_time = string_to_date '2010-01-01T00:00:00.000Z'
    event_time = self.string_to_date self.start
    elapsed_time = (event_time - base_time) * 1000
    elapsed_time.to_int
  end

  def get_delay_time
    return self.delay.to_int if self.delay
    0
  end
  
end
