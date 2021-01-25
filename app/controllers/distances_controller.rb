class DistancesController < ApplicationController
  def index
    if flash[:distance]
      @distance = Distance.new(flash[:distance])
    else
      @distance = Distance.new
    end
    if @current_user
      @distances = Distance.where(user_id: @current_user.id).order(:id).reverse_order.page(params[:page])
      @new_distance = Distance.where(user_id: @current_user.id).last
    else
      redirect_to root_path
    end

  end

  def new
    unless @current_user
      redirect_to root_path
    end

    if flash[:distance]
      @distance = Distance.new(flash[:distance])
    else
      @distance = Distance.new
    end
  end

  def create
    distance = Distance.create(distance_params_add_user_id)
    if distance.save
      flash[:notice] = "ただいまの飛距離 #{distance.distance.floor(1)} yard が登録されました。"
      redirect_to new_distance_path
    else
      redirect_to new_distance_path,
      flash: {
        distance: distance,
        error_messages:  ["START地点かEND地点の2地点がそろっていません"]
      }
      # flash[:error_messages] =  ["START地点かEND地点のどちらかがセットされていません"]
      # flash[:distance] = distance
      # redirect_to new_distance_path
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
    params.require(:distance).permit(:st_lat, :st_lng, :ed_lat, :ed_lng, tag_ids: [])
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