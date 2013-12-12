class DataController < ApplicationController

  def view
   json_string = [{ start:  "2010-01-01 00:01:00.000".to_datetime.iso8601(4), 
                   end:      "2010-01-01 00:10:00.000".to_datetime.iso8601(4), 
                   content:  "starburst",
                   editable: true,
                   id: 3},

                   { start:   "2010-01-01 00:02:15.100".to_datetime.iso8601(4), 
                   end:       "2010-01-01 00:05:30.400".to_datetime.iso8601(4), 
                   content:   "thunderclap",
                   id: 2 }
                   ].to_json

   render json: json_string
  end


end
