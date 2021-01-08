# == Schema Information
#
# Table name: distances
#
#  id         :bigint           not null, primary key
#  distance   :float(24)
#  ed_lat     :decimal(8, 6)
#  ed_lng     :decimal(9, 6)
#  st_lat     :decimal(8, 6)
#  st_lng     :decimal(9, 6)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Distance < ApplicationRecord

  validates :st_lat,
  :numericality => {
    :greater_than_or_equal_to => -90,
    :less_than_or_equal_to => 90,
    :message => 'が−90°〜90°の範囲外です',
  },
  allow_blank: true
  validates :st_lat, presence: true
  
  validates :st_lng,
  :numericality => {
    :greater_than_or_equal_to => -180,
    :less_than_or_equal_to => 180,
    :message => 'が−180°〜180°の範囲外です',
  },
  allow_blank: true
  validates :st_lng, presence: true
  
  validates :ed_lat,
  :numericality => {
    :greater_than_or_equal_to => -90,
    :less_than_or_equal_to => 90,
    :message => 'が−90°〜90°の範囲外です',
  },
  allow_blank: true
  validates :ed_lat, presence: true
  
  validates :ed_lng,
  :numericality => {
    :greater_than_or_equal_to => -180,
    :less_than_or_equal_to => 180,
    :message => 'が−180°〜180°の範囲外です',
  },
  allow_blank: true
  validates :ed_lng, presence: true

  include Math
  RADIUS_EARTH = 6378100 #地球の半径
  YARD_PER_METER = 0.9144 # メートルをヤードに変換する係数

  def self.calculate_distance(params) #地点間の距離を計算して、オブジェクトの値として登録する
    if !params[:st_lat].empty? &&
       !params[:st_lng].empty? && 
       !params[:ed_lat].empty? &&
       !params[:ed_lng].empty?
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
    params
  end

end
