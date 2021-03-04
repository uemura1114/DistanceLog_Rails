require 'rails_helper'

RSpec.describe UsersController, type: :request do
  describe "GET /users/new" do
    context 'ログインしていない状態でアクセスした場合' do
      before { get '/users/new' }

      it 'リクエストが成功すること' do
        expect(response.status).to eq 200
      end

      it 'newテンプレートをレンダリングすること' do
        expect(response).to render_template :new
      end

    end

    context 'ログイン状態(ユーザーID:2)でアクセスした場合' do
      let(:rspec_session) { { user_id: 2 } }
      before { get '/users/new' }

      it "'/distances/new'にリダイレクトすること" do
        expect(response).to redirect_to '/distances/new'
      end

      it 'ログインユーザーのIDが2であること' do
        expect(RSpec.configuration.session[:user_id]).to eq 2
      end

    end
  end

  describe "POST /users" do
    context '正しいユーザー情報がポストされたとき' do
      let(:params) do
        { user: {
            name: 'user123',
            password: '123456',
            password_confirmation: '123456',
           }
        }
      end

      it 'ユーザーが一人増えていること' do
        expect{ post '/users', params: params }.to change(User, :count).by(1)
      end

      it 'new_distance_pathにリダイレクトすること' do
        expect(post '/users', params: params).to redirect_to new_distance_path
      end

    end
    
    context '誤ったユーザー情報がポストされたとき' do
      let(:params) do
        { user: {
            name: 'user@123',
            password: '123',
            password_confirmation: '123456',
           }
        }
      end

      let(:headers) do
        { 'HTTP_REFERER' => 'http://localhost/users/new' }
      end

      before do
        post '/users', params: params, headers: headers
      end

      it 'リファラーにリダイレクトされること' do
        expect(response).to redirect_to('http://localhost/users/new')
      end

      it 'ユーザー名のエラーメッセージが含まれていること' do
        expect(flash[:error_messages]).to include 'ユーザー名は小文字英数字で入力してください'
      end

      it 'パスワードのエラーメッセージが含まれていること' do
        expect(flash[:error_messages]).to include 'パスワードは4文字以上で入力してください'
      end

      it 'パスワード（確認）のエラーメッセージが含まれていること' do
        expect(flash[:error_messages]).to include 'パスワード（確認）とパスワードの入力が一致しません'
      end

    end
  end

  describe 'GET /mypage' do
    context 'ログインしていない状態でアクセスしたとき' do
      before { get '/mypage' }

      it 'root_pathにリダイレクトされること' do
        expect(response).to redirect_to root_path
      end

    end

    context 'ログイン状態(ユーザーID:2)でアクセスした場合' do
      let(:rspec_session) { { user_id: 2 } }
      before { get '/mypage' }
      
      it 'レスポンスコードが200であること' do
        expect(response.status).to eq 200
      end

      it 'meテンプレートをレンダリングすること' do
        expect(response).to render_template :me
      end

      it 'ログインユーザーのIDが2であること' do
        expect(RSpec.configuration.session[:user_id]).to eq 2
      end

    end
  end
end
