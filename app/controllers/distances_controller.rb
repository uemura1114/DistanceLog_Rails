class DistancesController < ApplicationController
  def index
    if flash[:distance]
      @distance = Distance.new(flash[:distance])
    else
      @distance = Distance.new
    end
    @distances = Distance.all
  end

  def create
    distance = Distance.create(distance_params_add_user_id)
    if distance.save
      redirect_to distances_path,
        flash: {
          notice: "データ(ID=#{distance.id})が追加されました"
        }
    else
      redirect_to distances_path,
        flash: {
          distance: distance,
          error_messages: distance.errors.full_messages
        }
    end
  end

  def destroy
    distance = Distance.find(params[:id])
    distance.destroy
    redirect_to distances_path,
      flash: {
        notice: "データ(ID=#{distance.id})が削除されました"
      }
  end

  private

  def distance_params
    params.require(:distance).permit(:st_lat, :st_lng, :ed_lat, :ed_lng)
  end

  def distance_params_add_distance
    Distance.calculate_distance(distance_params)
  end

  def distance_params_add_user_id
    params = distance_params_add_distance
    params[:user_id] = @current_user.id
    params
  end

end