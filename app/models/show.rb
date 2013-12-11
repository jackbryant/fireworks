class Show < ActiveRecord::Base
   has_many :events
   has_attached_file :track
end
