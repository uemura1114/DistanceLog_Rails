class HomeController < ApplicationController
  def index
    if @current_user
      redirect_to new_distance_path
    end
  end
end
