class BoardsController < ApplicationController
  def index
    WebsocketRails[''].trigger :board_present
    render nothing: true
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

  def destroy
    # raise params.inspect
    @board = Board.find(params[:id])
    if @board.destroy 
      flash[:notice] = 'Board removed'
        redirect_to shows_path
      else
        raise "something the fuck went wrong in the Board Controller (destroy)"
    end
  end

  def board_status
    raise "whoop"
  end



  def board_params
    params.require(:board).permit(:name,:boardID)
  end
end
