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

  describe 'GET /distances/:id' do
    before { get "/distances/#{ id }" }

    context 'ログイン状態(ユーザーID:2)でそのユーザーの最新のdistanceデータにアクセスしたとき' do
      let(:rspec_session) { { user_id: 2} }
      let(:id) do
         Distance.where(user_id: RSpec.configuration.session[:user_id]).last.id
      end
      
      it 'リクエストが成功すること' do
        expect(response.status).to eq 200
      end

      it 'ユーザーID:2の最新データとNEWのラベルが表示されていること' do
        expect(response.body).to include "#{ Distance.where(id: id).first.distance.floor(1) } yd", 'NEW'
      end
    end

    context 'ログイン状態(ユーザーID:2)で別のユーザー(ユーザーID:3)の最新のdistanceデータにアクセスしたとき' do
      let(:rspec_session) { { user_id: 2} }
      let(:id) do
         Distance.where(user_id: 3).last.id
      end
      
      it 'distances_pathにリダイレクトされること' do
        expect(response).to redirect_to distances_path
      end

    end

    context 'ログイン状態(ユーザーID:2)で存在しないdistanceデータにアクセスしたとき' do
      let(:id) do
         9999
      end
      
      it 'distances_pathにリダイレクトされること' do
        expect(response).to redirect_to distances_path
      end

    end

    context 'ログインしていない状態で存在する最新のdistanceデータにアクセスしたとき' do
      let(:id) do
         Distance.last.id
      end
      
      it 'distances_pathにリダイレクトされること' do
        expect(response).to redirect_to root_path
      end

    end

    
  end

  describe 'DELETE /distances/:id' do
    context 'ログイン状態(ユーザーID:2)でそのユーザーの最新distanceデータを削除したとき' do
      let(:rspec_session) { { user_id: 2 } }
      let(:id) do
        Distance.where(user_id: RSpec.configuration.session[:user_id]).last.id
      end

      it '飛距離データがひとつ減っていること' do
        expect{ delete "/distances/#{ id }" }.to change(Distance, :count).by(-1)
      end

      it 'distances_pathにリダイレクトされること' do
        expect(delete "/distances/#{ id }").to redirect_to distances_path
      end

      it 'flashにメッセージが格納されていること' do
        delete "/distances/#{ id }"
        expect(flash[:notice]).to include "データが削除されました"
      end
    end

    context 'ログイン状態(ユーザーID:2)で、別のユーザー(ユーザーID:3)の最新disntanceデータを削除しようとしたとき' do
      let(:rspec_session) { { user_id: 2 } }
      let(:id) do
        Distance.where(user_id: 3).last.id
      end

      it 'distances_pathにリダイレクトされること' do
        expect(delete "/distances/#{ id }").to redirect_to distances_path
      end

    end
    
    context 'ログイン状態で、存在しないdistanceデータを削除しようとしたとき' do
      let(:id) do
        9999
      end

      it 'root_pathにリダイレクトされること' do
        expect(delete "/distances/#{ id }").to redirect_to root_path
      end
      
    end

    context 'ログインしていない状態で、存在する最新のdistanceデータを削除しようとしたとき' do
      let(:id) do
        Distance.last.id
      end
      
      it 'root_pathにリダイレクトされること' do
        expect(delete "/distances/#{ id }").to redirect_to root_path
      end
    end

  end

  describe 'GET /how' do
    before { get "/how" }

    context 'ログイン状態(ユーザーID:2)でアクセスしたとき' do
      let(:rspec_session) { { user_id: 2 } }
      
      it 'リクエストが成功すること' do
        expect(response.status).to eq 200
      end

      it 'howテンプレートをレンダリングすること' do
        expect(response).to render_template :how
      end

    end

    context 'ログインしていない状態でアクセスしたとき' do
      
      it 'リクエストが成功すること' do
        expect(response.status).to eq 200
      end
    
      it 'howテンプレートをレンダリングすること' do
        expect(response).to render_template :how
      end
      
    end
  end
end
