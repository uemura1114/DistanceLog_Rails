class DistancesController < ApplicationController
  def index
    @distance = Distance.new
  end

  def create
    Distance.create(distance_params)
  end

  private

  def distance_params
    params.require(:distance).permit(:st_lat, :st_lng, :ed_lat, :ed_lng)
  end

end