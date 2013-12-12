class Api::TimelinesController < ApplicationController
  respond_to :json

  
  
  def index
    @timeline = Event.all
    respond_with @timeline.as_json(except: [:created_at, :updated_at])
  end

  def destroy

    @timeline =  Event.find_by(id: params["id"])  

    # raise @timeline.inspect
    if @timeline.destroy
      respond_with @timeline, :location => api_timelines_url
    else
      "It's broken"
    end
  end

  def show
   @timeline = Event.where(show_id: params["id"])
   respond_with @timeline.as_json(except: [:created_at, :updated_at])
  end

  def create 
    # raise params.inspect
    @timeline =  Event.find_or_initialize_by(id: params["id"])
    
    @timeline.start = params[:start]
    @timeline.end = params[:end]
    @timeline.content = params[:content]
    @timeline.editable = true
    @timeline.firework_id = params[:firework_id]
    @timeline.show_id = params[:show_id]
    

    if @timeline.save 
      respond_with @timeline, :location => api_timelines_url
    else
      "It's broken"
    end 
  end

end    


