class TracksController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  def create
  	@show.update(track_url: params[:track_url])
  end

end
