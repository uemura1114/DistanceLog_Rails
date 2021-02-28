require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #new' do
    context 'ログインしていない状態でアクセスした場合' do
      before do
        get :new
      end
  
      it 'レスポンスコードが200であること' do
        expect(response).to have_http_status(200)
      end
  
      it 'newテンプレートをレンダリングすること' do
        expect(response).to render_template :new
      end
  
      it '新しいオブジェクトがビューに渡されること' do
        expect(assigns(:user)).to be_a_new User
      end
    end

    context 'ログイン状態でアクセスした場合' do
      before do
        session[:user_id] = 2
        get :new
      end
      it 'new_distance_pathにリダイレクトすること' do
        expect(response).to redirect_to new_distance_path
      end
    end

  end

  describe 'POST #create' do
    before do
      @referer = 'http://localhost'
      @request.env['HTTP_REFERER'] = @referer
    end

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
        expect{ post :create, params: params }.to change(User, :count).by(1)
      end

      it 'new_distance_pathにリダイレクトすること' do
        expect(post :create, params: params).to redirect_to new_distance_path
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

      before do
        post :create, params: params
      end

      it 'リファラーにリダイレクトされること' do
        expect(response).to redirect_to(@referer)
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

  describe 'GET #me' do
    context 'ログインしていない状態でアクセスしたとき' do
      before do
        get :me
      end

      it 'rootpathにリダイレクトされること' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user_id=2のユーザーでログインしてアクセスしたとき' do
      before do
        session[:user_id] = 2
        get :me
      end

      it 'レスポンスコードが200であること' do
        expect(response).to have_http_status(200)
      end

      it 'meテンプレートをレンダリングすること' do
        expect(response).to render_template :me
      end

      it 'distancesオブジェクトがビューに渡されること' do
        expect(assigns(:distances)).to eq Distance.where(user_id: 2)
      end
    end
  end

end
