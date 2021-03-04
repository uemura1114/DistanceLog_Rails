require 'rails_helper'

RSpec.describe DistancesController, type: :controller do
  describe 'GET #index' do
    context 'ログインしていない状態でアクセスした場合' do
      before do
        get :index
      end

      it 'root_pathにリダイレクトされること' do
        expect(response).to redirect_to root_path
      end
      
    end

    context 'user_id=2のユーザーでログインしてindexの1ページめにアクセスしたとき' do
      let(:params) do
        { page: 1 }
      end

      before do
        session[:user_id] = 2
        get :index, params: params
      end

      it 'レスポンスコードが200であること' do
        expect(response).to have_http_status(200)
      end

      it 'indexテンプレートをレンダリングすること' do
        expect(response).to render_template :index
      end

      it 'distancesオブジェクトがビューに渡されること' do
        expect(assigns(:distances)).to eq Distance.where(user_id: 2).order(:id).reverse_order.page(params[:page])
      end

      it 'new_distanceオブジェクトがビューに渡されること' do
        expect(assigns(:new_distance)).to eq Distance.where(user_id: 2).last
      end
    end
  end

  describe 'GET #new' do
    context 'ログインしていない状態でアクセスした場合' do
      before do
        get :new
      end

      it 'root_pathにリダイレクトされること' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user_id=2のユーザーでログインしてアクセスしたとき' do
      before do
        session[:user_id] = 2
        get :new
      end

      it 'レスポンスコードが200であること' do
        expect(response).to have_http_status(200)
      end

      it 'newテンプレートをレンダリングすること' do
        expect(response).to render_template :new
      end

      it '新しいdistanceオブジェクトがビューに渡されること' do
        expect(assigns(:distance)).to be_a_new Distance
      end

    end

  end

end
