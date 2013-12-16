require 'spec_helper'



describe Show do
  
  let(:show_id) { 999 }
  let(:show) { FactoryGirl.create( :show, id: 999) }
  let(:delays) { [50, 0, 100, 100] }
  let(:event_timings) { [5000, 6000, 8000, 10200] }


  before :each do 
    #create some events.
    FactoryGirl.create(:event, show_id: 1, start: '2010-01-01T00:00:05.001Z' )
    FactoryGirl.create(:event, show_id: show_id, start: '2010-01-01T00:00:06.300Z' , delay: 100 )
    FactoryGirl.create(:event, show_id: show_id, start: '2010-01-01T00:00:07.001Z' )
    FactoryGirl.create(:event, show_id: show_id, start: '2010-01-01T00:00:09.001Z' )   
  end


  it "will return a list of events for a show" do
    events = show.get_events_from_show 999
    expect( events.count ).to eq 3
  end

  it "convert timeline timings to relative timings" do
    relative_timings = show.get_relative_timings event_timings
    expect( relative_timings ).to eq [5000, 1000, 2000, 2200]
  end

  it "will remove delays from event timings" do
    timings_without_delays = show.remove_delays event_timings, delays
    expect( timings_without_delays ).to eq [4950, 6000, 7900, 10100]
  end

  it "creates relative timed events with delay removed" do
    relative_timings = show.get_relative_timings event_timings
    relative_timings_without_delays = show.remove_delays relative_timings, delays
    expect( relative_timings_without_delays ).to eq [4950, 1000, 1900, 2100]
  end

  it "creates a timing string" do
    
  end
end

