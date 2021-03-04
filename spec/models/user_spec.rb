# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  name            :string(255)      not null
#  password_digest :string(255)      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_name  (name) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#create' do
    let(:user) { User.new(params) }
    context '有効なparamsが渡されたとき' do
      let(:params) { {name: 'testuse', password: '123456'} }
      it 'バリデーションを通過すること' do
        expect(user).to be_valid
      end
    end
    
    context 'nameに大文字が使われたとき' do
      let(:params) { {name: 'testuseR', password: '123456'} }
      it 'バリデーションを通過しないこと' do
        expect(user.valid?).to eq(false)
      end
      it '正しいエラーメッセージが出力されること' do
        user.valid?
        expect(user.errors.messages[:name]).to include('は小文字英数字で入力してください')
      end
    end

    context 'nameに記号が使われたとき' do
      let(:params) { {name: 'test@user', password: '123456'} }
      it 'バリデーションを通過しないこと' do
        expect(user.valid?).to eq(false)
      end
      it '正しいエラーメッセージが出力されること' do
        user.valid?
        expect(user.errors.messages[:name]).to include('は小文字英数字で入力してください')
      end
    end

    context 'nameが16文字のとき' do
      let(:params) { {name: 'testusertestuser', password: '123456'} }
      it 'バリデーションを通過すること' do
        expect(user).to be_valid
      end
    end

    context 'nameが17文字のとき' do
      let(:params) { {name: 'testusertestusert', password: '123456'} }
      it 'バリデーションを通過しないこと' do
        expect(user.valid?).to eq(false)
      end
      it '正しいエラーメッセージが出力されること' do
        user.valid?
        expect(user.errors.messages[:name]).to include('は16文字以内で入力してください')
      end
    end

    context 'nameがすでに登録済みのとき' do
      let(:params) { {name: 'user1', password: '123456'} }
      it 'バリデーションを通過しないこと' do
        expect(user.valid?).to eq(false)
      end
      it '正しいエラーメッセージが出力されること' do
        user.valid?
        expect(user.errors.messages[:name]).to include('はすでに存在します')
      end
    end

    context 'nameが存在しないとき' do
      let(:params) { {name: '', password: '123456'} }
      it 'バリデーションを通過しないこと' do
        expect(user.valid?).to eq(false)
      end
      it '正しいエラーメッセージが出力されること' do
        user.valid?
        expect(user.errors.messages[:name]).to include('を入力してください', 'は小文字英数字で入力してください')
      end
    end

    context 'passwordが3文字のとき' do
      let(:params) { {name: 'testuser', password: '123'} }
      it 'バリデーションを通過しないこと' do
        expect(user.valid?).to eq(false)
      end
      it '正しいエラーメッセージが出力されること' do
        user.valid?
        expect(user.errors.messages[:password]).to include('は4文字以上で入力してください')
      end
    end

    context 'password_confirmationがpasswordと一致しないとき' do
      let(:params) { {name: 'testuser', password: '1234', password_confirmation: '12345'} }
      it 'DBへの登録が成功しないこと' do
        expect(user.save).to eq(false)
      end
      it '正しいエラーメッセージが出力されること' do
        user.valid?
        expect(user.errors.messages[:password_confirmation]).to include('とパスワードの入力が一致しません')
      end
    end

  end

  describe 'Association' do
    let(:association) { described_class.reflect_on_association(target) }

    context 'distances' do
      let(:target) { :distances }
      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'Distance' }
    end

  end

end
