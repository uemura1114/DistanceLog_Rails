class Distance < ApplicationRecord

  include Math
  RADIUS_EARTH = 6378100 #地球の半径
  YARD_PER_METER = 0.9144 # メートルをヤードに変換する係数

  def self.calculate_distance(params) #地点間の距離を計算して、オブジェクトの値として登録する
    params[:st_lat] = params[:st_lat].to_f
    params[:st_lng] = params[:st_lng].to_f
    params[:ed_lat] = params[:ed_lat].to_f
    params[:ed_lng] = params[:ed_lng].to_f
    diff_lat = (params[:st_lat] - params[:ed_lat]) * PI / 180 #緯度の差をラジアンに変換
    diff_lng = (params[:st_lng] - params[:ed_lng]) * PI / 180 #経度の差をラジアンに変換
    ave_lat = (params[:st_lat] + params[:ed_lat]) / 2 * PI / 180 #緯度の平均値をラジアンに変換
    y = RADIUS_EARTH * Math.tan(diff_lat)
    x = RADIUS_EARTH * Math.cos(ave_lat) * Math.tan(diff_lng)
    distance = (y ** 2 + x ** 2) ** 0.5 / YARD_PER_METER
    params[:distance] = distance
    params
  end
end
