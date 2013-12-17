require 'spec_helper'

describe Event do

  before( :each ) do
     
  end

  it "can turn a date string into a date object" do
    event = FactoryGirl.create(:event, content: "Green Sparkle", start: '2010-01-01T00:00:05.001Z' )
    date_object = event.string_to_date '2010-01-01T00:00:05.001Z'

    expect( date_object.class  ).to eq Time
  end

  it "can tell me the time in milliseconds an event occurs" do
    event = FactoryGirl.create(:event, content: "Green Sparkle", start: '2010-01-01T00:00:05.001Z' )
    expect( event.get_start_time_from_base  ).to eq 5001  # 5 seconds
  end

end