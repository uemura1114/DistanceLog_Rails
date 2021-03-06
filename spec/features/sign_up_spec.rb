require 'rails_helper'

RSpec.describe 'サインアップテスト', type: :feature do
  before do
    visit new_user_path
  end

  context '有効なユーザー情報でサインアップされたとき' do
    before do
      fill_in 'ユーザー名', with: 'user999'
      fill_in 'パスワード', with: 'password999'
      fill_in 'パスワード（確認）', with: 'password999'
      click_button '登録'
    end
    it 'new_distance_pathにリダイレクトされること' do
      expect(current_path).to eq new_distance_path
    end
    it '測定画面が表示されること' do
      expect(page).to have_content '位置情報取得までしばらくお待ちください'
    end
  end

  context '無効なユーザー名でサインアップされたとき' do
    before do
      fill_in 'ユーザー名', with: 'user@111'
      fill_in 'パスワード', with: 'password999'
      fill_in 'パスワード（確認）', with: 'password999'
      click_button '登録'
    end
    it 'ユーザー名のエラーメッセージが表示される' do
      expect(page).to have_content 'ユーザー名は小文字英数字で入力してください'
    end
  end

  context '無効なパスワードでサインアップされたとき' do
    before do
      fill_in 'ユーザー名', with: 'user999'
      fill_in 'パスワード', with: '999'
      fill_in 'パスワード（確認）', with: '999'
      click_button '登録'
    end
    it 'パスワードのエラーメッセージが表示される' do
      expect(page).to have_content 'パスワードは4文字以上で入力してください' 
    end
  end

  context '無効なパスワード(確認)でサインアップされたとき' do
    before do
      fill_in 'ユーザー名', with: 'user999'
      fill_in 'パスワード', with: 'password999'
      fill_in 'パスワード（確認）', with: '999'
      click_button '登録'
    end
    it 'パスワード（確認）のエラーメッセージが表示される' do
      expect(page).to have_content 'パスワード（確認）とパスワードの入力が一致しません' 
    end
  end
  
end