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
        user_id: 2
      )
    end

    context '位置情報が有効範囲の場合' do
      it 'インスタンスがバリデーションを通過すること' do
        expect(@distance).to be_valid
      end
    end

    context 'st_latの値がnilの場合' do
      before do
        @distance.st_lat = nil
      end
      it 'バリデーションを通過しない' do
        expect(@distance.valid?).to eq(false)
      end
      it '正しいエラーメッセージが出力されること' do
        @distance.valid?
        expect(@distance.errors.messages[:st_lat]).to include('を入力してください')
      end
    end
      
    context 'st_latの値が−100の場合' do
      before do
        @distance.st_lat = -100
      end
      it 'バリデーションを通過しない' do
        expect(@distance.valid?).to eq(false)
      end
      it '正しいエラーメッセージが出力されること' do
        @distance.valid?
        expect(@distance.errors.messages[:st_lat]).to include('が−90°〜90°の範囲外です')
      end
    end

    context 'st_latの値が100の場合' do
      before do
        @distance.st_lat = 100
      end
      it 'バリデーションを通過しない' do
        expect(@distance.valid?).to eq(false)
      end
      it '正しいエラーメッセージが出力されること' do
        @distance.valid?
        expect(@distance.errors.messages[:st_lat]).to include('が−90°〜90°の範囲外です')
      end
    end

    context 'ed_latの値がnilの場合' do
      before do
        @distance.ed_lat = nil
      end
      it 'バリデーションを通過しない' do
        expect(@distance.valid?).to eq(false)
      end
      it '正しいエラーメッセージが出力されること' do
        @distance.valid?
        expect(@distance.errors.messages[:ed_lat]).to include('を入力してください')
      end
    end

    context 'ed_latの値が-100の場合' do
      before do
        @distance.ed_lat = -100
      end
      it 'バリデーションを通過しない' do
        expect(@distance.valid?).to eq(false)
      end
      it '正しいエラーメッセージが出力されること' do
        @distance.valid?
        expect(@distance.errors.messages[:ed_lat]).to include('が−90°〜90°の範囲外です')
      end
    end
    
    context 'ed_latの値が100の場合' do
      before do
        @distance.ed_lat = 100
      end
      it 'バリデーションを通過しない' do
        expect(@distance.valid?).to eq(false)
      end
      it '正しいエラーメッセージが出力されること' do
        @distance.valid?
        expect(@distance.errors.messages[:ed_lat]).to include('が−90°〜90°の範囲外です')
      end
    end
    
    context 'st_lngの値がnilの場合' do
      before do
        @distance.st_lng = nil
      end
      it 'バリデーションを通過しない' do
        expect(@distance.valid?).to eq(false)
      end
      it '正しいエラーメッセージが出力されること' do
        @distance.valid?
        expect(@distance.errors.messages[:st_lng]).to include('を入力してください')
      end
    end
    
    context 'st_lngの値が200の場合' do
      before do
        @distance.st_lng = 200
      end
      it 'バリデーションを通過しない' do
        expect(@distance.valid?).to eq(false)
      end
      it '正しいエラーメッセージが出力されること' do
        @distance.valid?
        expect(@distance.errors.messages[:st_lng]).to include('が−180°〜180°の範囲外です')
      end
    end
    
    context 'st_lngの値が-200の場合' do
      before do
        @distance.st_lng = -200
      end
      it 'バリデーションを通過しない' do
        expect(@distance.valid?).to eq(false)
      end
      it '正しいエラーメッセージが出力されること' do
        @distance.valid?
        expect(@distance.errors.messages[:st_lng]).to include('が−180°〜180°の範囲外です')
      end
    end
    
    context 'ed_lngの値がnilの場合' do
      before do
        @distance.ed_lng = nil
      end
      it 'バリデーションを通過しない' do
        expect(@distance.valid?).to eq(false)
      end
      it '正しいエラーメッセージが出力されること' do
        @distance.valid?
        expect(@distance.errors.messages[:ed_lng]).to include('を入力してください')
      end
    end
    
    context 'ed_lngの値が200の場合' do
      before do
        @distance.ed_lng = 200
      end
      it 'バリデーションを通過しない' do
        expect(@distance.valid?).to eq(false)
      end
      it '正しいエラーメッセージが出力されること' do
        @distance.valid?
        expect(@distance.errors.messages[:ed_lng]).to include('が−180°〜180°の範囲外です')
      end
    end
    
    context 'ed_lngの値が-200の場合' do
      before do
        @distance.ed_lng = -200
      end
      it 'バリデーションを通過しない' do
        expect(@distance.valid?).to eq(false)
      end
      it '正しいエラーメッセージが出力されること' do
        @distance.valid?
        expect(@distance.errors.messages[:ed_lng]).to include('が−180°〜180°の範囲外です')
      end
    end

  end

  describe 'Association' do
    let(:association) { described_class.reflect_on_association(target) }
    
    context 'distance_tag_relations' do
      let(:target) { :distance_tag_relations }
      it { expect(association.macro).to eq :has_many }
      it { expect(association.options).to eq :dependent => :delete_all }
      it { expect(association.class_name).to eq 'DistanceTagRelation'}
    end
    
    context 'tags' do
      let(:target) { :tags }
      it { expect(association.macro).to eq :has_many }
      it { expect(association.options).to eq :through => :distance_tag_relations }
      it { expect(association.class_name).to eq 'Tag'}
    end
    
    context 'user' do
      let(:target) { :user }
      it { expect(association.macro).to eq :belongs_to }
      it { expect(association.class_name).to eq 'User'}
    end

  end

end