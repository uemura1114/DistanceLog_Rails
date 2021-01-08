class DistancesController < ApplicationController
  def index
    @distance = Distance.new
  end

  def create
    Distance.create(distance_params_add_distance)
    binding.pry
  end

  private

  def distance_params
    params.require(:distance).permit(:st_lat, :st_lng, :ed_lat, :ed_lng)
  end

  def distance_params_add_distance
    Distance.calculate_distance(distance_params)
  end

end