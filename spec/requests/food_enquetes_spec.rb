require 'rails_helper'

RSpec.describe "FoodEnquetes", type: :request do
  describe '正常' do
    context 'アンケートに回答する' do
      it '回答できること' do
        # アンケートページへのアクセス
        get '/food_enquetes/new'
        # 正常にアクセスできることを確認する
        expect(response).to have_http_status(200)

        # アンケートの正常な入力値を送信する
        post '/food_enquetes', params:{ food_enquete: FactoryBot.attributes_for(:food_enquete_tanaka) }
        # リダイレクト先に移動
        follow_redirect!
        
        # 送信完了のメッセージが含まれていることを確認する
        expect(response.body).to include 'お食事に関するアンケートを送信しました'
      end
    end
  end

   describe '異常' do
    context "アンケートに回答する" do
      it "エラーメッセージが表示されること" do
        get "/food_enquetes/new"
        expect(response).to have_http_status(200)
    
        # [Point.3-15-6]異常な入力値を送信します。
        post "/food_enquetes", params: { food_enquete: { name: '' } }
        # [Point.3-15-7]送信完了のメッセージが含まれないことを検証します。
        expect(response.body).not_to include "お食事に関するアンケートを送信しました"
      end
    end
  end
end
