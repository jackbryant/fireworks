class FireworksController < ApplicationController
  def index
    @firework = Firework.new
    @fireworks = Firework.all
     
  end

  def create
    @firework = Firework.create(firework_params)
    if @firework.save 
      flash[:notice] = 'New firework added'
      redirect_to fireworks_path
    else
      raise "something the fuck went wrong in the Fireworks Controller (create)"
    end
  end

  def destroy

    # raise params.inspect
    @firework = Firework.find(params[:id])
    if @firework.destroy 
      flash[:notice] = 'Firework removed'
        redirect_to fireworks_path
      else
        raise "something the fuck went wrong in the Fireworks Controller (destroy)"
    end
  end

   def firework_params
    params.require(:firework).permit(:name, :delay, :duration, :colour)
  end
end


