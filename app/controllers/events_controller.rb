class EventsController < ApplicationController

  def create
    @show = Show.find(params[:show_id])

    @event = @show.events.create(params[:event].permit(:start, :end, :content))
    redirect_to edit_show_path(@show)
   # Event.create(params[:event].permit(:start, :end, :content, :show_id))
  end
end
