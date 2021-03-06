require 'rails_helper'

RSpec.describe 'サインインテスト', type: :feature do
  before do
    visit root_path
  end

  context '有効なユーザー名とパスワードでサインインされたとき' do
    before do
      fill_in 'ユーザー名', with: 'user1'
      fill_in 'パスワード', with: '1111'
      click_button 'ログイン'
    end

    it 'new_distance_pathにリダイレクトされること' do
      expect(current_path).to eq new_distance_path
    end
    it '測定画面が表示されること' do
      expect(page).to have_content '位置情報取得までしばらくお待ちください'
    end
  end

  context '無効なユーザー名とパスワードでサインインされたとき' do
    before do
      fill_in 'ユーザー名', with: 'user0'
      fill_in 'パスワード', with: '1111'
      click_button 'ログイン'
    end

    it 'ログイン失敗のメッセージが表示される' do
      expect(page).to have_content 'ログインに失敗しました'
    end
  end
  
end