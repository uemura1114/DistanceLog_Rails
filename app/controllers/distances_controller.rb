class DistancesController < ApplicationController
  def index
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
    if @current_user
      distance = Distance.new(distance_params_add_user_id)
      if distance.save
        flash[:notice] = "ただいまの飛距離 #{distance.distance.floor(1)} yard が登録されました。"
        redirect_to new_distance_path
      else
        redirect_to new_distance_path,
        flash: {
          distance: distance,
          error_messages:  ["START地点とEND地点の2地点がそろっていません"]
        }
      end
    else
      redirect_to root_path
    end

  end

  def show
    if Distance.exists?(id: params[:id])
      if @current_user
        if Distance.find(params[:id]).user_id == @current_user.id
          @distance = Distance.find(params[:id])
          @new_distance = Distance.where(user_id: @current_user.id).last
        else
          redirect_to distances_path
        end
      else
        redirect_to distances_path
      end
    else
      redirect_to distances_path
    end
  end

  def destroy
    distance = Distance.find(params[:id])
    if distance.prohibited
      redirect_to distances_path,
        flash: {
          notice: "このデータは削除できません"
        }
    else
      distance.destroy
      redirect_to distances_path,
        flash: {
          notice: "データ(ID=#{distance.id})が削除されました"
        }
    end
  end

  def how
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