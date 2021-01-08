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
require 'test_helper'

class DistanceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
