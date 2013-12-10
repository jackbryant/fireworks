class ShowsController < ApplicationController
  def index
    @show = Show.new
    @shows = Show.all
    
    @board = Board.new
    @boards = Board.all
  end

  def create
    # puts params.inspect
    @show = Show.create(show_params)

    if @show .save 
      flash[:notice] = 'New show created'
      redirect_to shows_path
    else
      raise "something the fuck went wrong in the Shows Controller"
    end
  end

  def show_params
    params.require(:show).permit(:name)
  end
end
