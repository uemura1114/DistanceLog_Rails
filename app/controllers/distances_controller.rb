class DistancesController < ApplicationController
  def index
    @distance = Distance.new
    @distances = Distance.all
  end

  def create
    Distance.create(distance_params_add_distance)
    redirect_to distances_path, flash: { success: 'データが追加されました'}
  end

  def destroy
    distance = Distance.find(params[:id])
    distance.destroy
    redirect_to distances_path, flash: { success: 'データが削除されました'}
  end

  private

  def distance_params
    params.require(:distance).permit(:st_lat, :st_lng, :ed_lat, :ed_lng)
  end

  def distance_params_add_distance
    Distance.calculate_distance(distance_params)
  end

end