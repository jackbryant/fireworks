class BoardsController < ApplicationController
  
  def index
    render nothing: true
  end

  def create
    @boards = Board.create(board_params)

    if @boards.save 
      flash[:notice] = 'New board added'
      redirect_to shows_path
    else
      raise "There's been an error captain, in the boards controller."
    end
  end

  def destroy
    @board = Board.find(params[:id])
    if @board.destroy 
      flash[:notice] = 'Board removed'
        redirect_to shows_path
      else
        raise "There's been an error captain, in the boards controller."
    end
  end

  def board_status
    raise "whoop"
  end

  def board_params
    params.require(:board).permit(:name,:boardID)
  end
  
end
