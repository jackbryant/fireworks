class ShowsController < ApplicationController
  def index
    @show = Show.new
    @shows = Show.all
    @board = Board.new
    @boards = Board.all

    # Ensure that we have at least one firework
    @fireworks =  Firework.all 
    if @fireworks.count == 0
      Firework.create(name: "Golden Blaster", duration: 100, delay: 123, colour: 3, cant_remove:true )
    end
    
  end

  def create
    @show = Show.create(show_params)

    if @show.save 
      flash[:notice] = 'New show created'
      redirect_to shows_path
    else
      raise "something the fuck went wrong in the Shows Controller"
    end
  end

  def update
    # raise params
  end

  def edit
      @show = Show.find(params[:id])
      @event = Event.new
      @fireworks = Firework.all
  end


  def destroy
    @show = Show.find(params[:id])
    if @show.destroy 
      flash[:notice] = 'Show removed'
        redirect_to @show
      else
        raise "something the fuck went wrong in the Shows Controller (destroy)"
    end
  end

  def download
  show = Show.find(params[:id])
  send_data show.construct_timings_file,
    :filename => "timings.rb",
    :type => "text/plain"
end



  def show_params
    params.require(:show).permit(:name)
  end
end
