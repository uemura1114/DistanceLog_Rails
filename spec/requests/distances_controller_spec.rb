require 'rails_helper'

RSpec.describe DistancesController, type: :request do
  describe "GET /distances" do
    context 'ログインしていない状態でアクセスした場合' do
      before{ get '/distances' }
      
      it 'root_pathにリダイレクトされること' do
        expect(response).to redirect_to root_path
      end

    end

    context 'ログイン状態(ユーザーID:2)でアクセスした場合' do
      let(:rspec_session) { { user_id: 2 } }
      before { get '/distances' }
       
      it 'リクエストが成功すること' do
        expect(response.status).to eq 200
      end

      it 'indexテンプレートをレンダリングすること' do
        expect(response).to render_template :index
      end

      it 'ログインユーザーのIDが2であること' do
        expect(RSpec.configuration.session[:user_id]).to eq 2
      end

      it 'user_id=2のデータが表示されていること' do
        expect(response.body).to include '480.6 yd', '189.9 yd', '294.6 yd', '802.7 yd', '1254.9 yd', '835.7 yd', '414.1 yd', '1084.2 yd', '228.9 yd', '757.5 yd' 
      end

    end
  end

  describe "GET /distances/new" do
    context 'ログインしていない状態でアクセスした場合' do
      before { get '/distances/new' }

      it 'root_pathにリダイレクトされること' do
        expect(response).to redirect_to root_path
      end

    end

    context 'ログイン状態(ユーザーID:2)でアクセスした場合' do
      let(:rspec_session) { { user_id: 2 } }
      before { get '/distances/new' }

      it 'リクエストが成功すること' do
        expect(response.status).to eq 200
      end

      it 'newテンプレートをレンダリングすること' do
        expect(response).to render_template :new
      end
      
    end
  end

  describe "POST /distances" do
    context 'ログイン状態(ユーザーID:2)で正しい位置情報がポストされたとき' do
      let(:rspec_session) { { user_id: 2 } }
      let(:params) do
        { distance: {
            st_lat: '35.123456',
            st_lng: '141.123456',
            ed_lat: '35.234567',
            ed_lng: '141.234567',
            tag_ids: ['1'],
          }
        }
      end

      it '飛距離データがひとつ増えていること' do
        expect{ post '/distances', params: params }.to change(Distance, :count).by(1)
      end

      it 'flashにメッセージが格納されること' do
        post '/distances', params: params
        expect(flash[:notice]).to include 'ただいまの飛距離'
      end

      it 'new_distance_pathにリダイレクトすること' do
        expect(post '/distances', params: params).to redirect_to new_distance_path
      end

    end

    context 'ログイン状態(ユーザーID:2)でSTART地点のみSETしてポストされたとき' do
      let(:rspec_session) { { user_id: 2 } }
      let(:params) do
        { distance: {
            st_lat: '35.1234546',
            st_lng: '141.123456',
            ed_lat: '',
            ed_lng: '',
            tag_ids: ['1'],
          }
        }
      end

      it 'flashにSTART地点のデータと、エラーメッセージが格納されていること' do
        post '/distances', params: params
        expect(flash[:distance]).to be_truthy
        expect(flash[:error_messages]).to include 'START地点とEND地点の2地点がそろっていません'
      end

      it 'new_distance_pathにリダイレクトすること' do
        expect(post '/distances', params: params).to redirect_to new_distance_path
      end

    end

    context 'ログインしていない状態で正しい位置情報がポストされたとき' do
      let(:params) do
        { distance: {
            st_lat: '35.123456',
            st_lng: '141.123456',
            ed_lat: '35.234567',
            ed_lng: '141.234567',
            tag_ids: ['1'],
          }
        }
      end

      it 'root_pathにリダイレクトすること' do
        expect(post '/distances', params: params).to redirect_to root_path
      end

    end
  end
end
