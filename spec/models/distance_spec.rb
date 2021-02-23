# == Schema Information
#
# Table name: distances
#
#  id         :bigint           not null, primary key
#  distance   :float(24)
#  ed_lat     :decimal(8, 6)
#  ed_lng     :decimal(9, 6)
#  prohibited :boolean          default(FALSE), not null
#  st_lat     :decimal(8, 6)
#  st_lng     :decimal(9, 6)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_distances_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Distance, type: :model do
  describe '#calculate_distance' do

    before do
      @params1 =  ActionController::Parameters.new({"st_lat"=>"35.689487", "st_lng"=>"139.691706", "ed_lat"=>"35.689725", "ed_lng"=>"139.693444", "tag_ids"=>["", "1"]}).permit(:st_lat, :st_lng, :ed_lat, :ed_lng, tag_ids: [])

      @result_params1 = ActionController::Parameters.new({"st_lat"=>35.689487, "st_lng"=>139.691706, "ed_lat"=>35.689725, "ed_lng"=>139.693444, "tag_ids"=>["", "1"], "distance"=>174.27151441025242} ).permit(:st_lat, :st_lng, :ed_lat, :ed_lng, :distance, tag_ids: [])
    end

    context 'params1の値が渡された場合' do
      it 'result_params1と同じ結果が出力されること' do
        expect(Distance.calculate_distance(@params1)).to eq @result_params1
      end
    end
  end

  describe '#create' do
    before do 
      @distance = Distance.new(
        st_lat: 35.689487,
        st_lng: 139.691706,
        ed_lat: 35.689725,
        ed_lng: 139.693444,
        distance: 174.27151441025242,
        user_id: 1
      )

      @invalid_distance = Distance.new(
        st_lat: -139.691706,
        st_lng: -200.000000,
        ed_lat: 139.693444,
        ed_lng: 200.000000
      )
    end

    context '位置情報が有効範囲の場合' do
      it 'インスタンスがバリデーションを通過すること' do
        expect(@distance).to be_valid
      end
    end

    context 'latitudeが無効範囲またはnilの場合' do
      it 'st_latの値がなければバリデーションを通過しないこと' do
        @distance.st_lat = nil
        expect(@distance.valid?).to eq(false)
      end

      it 'st_latの値が−100の場合、バリデーションを通過しないこと' do
        @distance.st_lat = -100
        expect(@distance.valid?).to eq(false)
      end

      it 'st_latの値が100の場合、バリデーションを通過しないこと' do
        @distance.st_lat = 100
        expect(@distance.valid?).to eq(false)
      end

      it 'ed_latの値がなければバリデーションを通過しないこと' do
        @distance.ed_lat = nil
        expect(@distance.valid?).to eq(false)
      end

      it 'ed_latの値が-100の場合、バリデーションを通過しないこと' do
        @distance.ed_lat = -100
        expect(@distance.valid?).to eq(false)
      end

      it 'ed_latの値が100の場合、バリデーションを通過しないこと' do
        @distance.ed_lat = 100
        expect(@distance.valid?).to eq(false)
      end
    end


    context 'longitudeが無効範囲またはnilの場合' do
      it 'st_lngの値がなければバリデーションを通過しないこと' do
        @distance.st_lng = nil
        expect(@distance.valid?).to eq(false)
      end

      it 'st_lngの値が−100の場合、バリデーションを通過しないこと' do
        @distance.st_lng = -200
        expect(@distance.valid?).to eq(false)
      end

      it 'st_lngの値が100の場合、バリデーションを通過しないこと' do
        @distance.st_lng = 200
        expect(@distance.valid?).to eq(false)
      end

      it 'ed_lngの値がなければバリデーションを通過しないこと' do
        @distance.ed_lng = nil
        expect(@distance.valid?).to eq(false)
      end

      it 'ed_lngの値が-100の場合、バリデーションを通過しないこと' do
        @distance.ed_lng = -200
        expect(@distance.valid?).to eq(false)
      end

      it 'ed_lngの値が100の場合、バリデーションを通過しないこと' do
        @distance.ed_lng = 200
        expect(@distance.valid?).to eq(false)
      end
    end

  end

end