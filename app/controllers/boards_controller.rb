class BoardsController < ApplicationController
  def index
  end

  def create
    # puts params.inspect
    @boards = Board.create(board_params)

    if @boards.save 
      flash[:notice] = 'New board added'
      redirect_to shows_path
    else
      raise "something the fuck went wrong in the Board Controller"
    end
  end



  def board_params
    params.require(:board).permit(:name)
  end
end
