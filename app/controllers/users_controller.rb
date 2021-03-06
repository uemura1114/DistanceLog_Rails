class UsersController < ApplicationController
  def new
    if @current_user
      redirect_to new_distance_path
    end
    @user = User.new(flash[:user])
  end

  def create
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      redirect_to new_distance_path
    else
      redirect_back fallback_location: new_user_path, flash: {
        user: user_params,
        error_messages: user.errors.full_messages
      }
    end
  end

  def me
    if @current_user
      @distances = Distance.where(user_id: @current_user.id)
    else
      redirect_to root_path
    end
  end

  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation)
  end
end
