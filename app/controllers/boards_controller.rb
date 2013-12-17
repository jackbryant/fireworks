class BoardsController < ApplicationController
  
  protect_from_forgery :except => :auth # stop rails CSRF protection for this action

  Pusher.app_id = '61655'
  Pusher.key = '26f4232b489d7c8a2e22'
  Pusher.secret = 'da6df554f835d0121657'

  def auth
    response = Pusher[params[:channel_name]].authenticate(params[:socket_id], {
      :user_id => 1, 
    })
    render :json => response
  end

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