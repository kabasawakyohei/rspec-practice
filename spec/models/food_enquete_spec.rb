require 'rails_helper'

RSpec.describe FoodEnquete, type: :model do
  describe '正常系の機能' do
    context '回答する' do
      it '正しく登録できること 料理:やきそば food_id: 2, 
                            満足度:良い score: 3, 
                            希望するプレゼント:ビール飲み放題 present_id: 1)' do

        enquete = FactoryBot.build(:food_enquete_tanaka)

        # [Point.3-3-2]「バリデーションが正常に通ること(バリデーションエラーが無いこと)」を検証します。
        expect(enquete).to be_valid

        # [Point.3-3-3]テストデータを保存します。
        enquete.save

        # [Point.3-3-4][Point.3-3-3]で保存したデータを取得します。
        answered_enquete = FoodEnquete.find(1);

        # [Point.3-3-5][Point.3-3-1]で作成したデータを同一か検証します。
        expect(answered_enquete.name).to eq('田中 太郎')
        expect(answered_enquete.mail).to eq('taro.tanaka@example.com')
        expect(answered_enquete.age).to eq(25)
        expect(answered_enquete.food_id).to eq(2)
        expect(answered_enquete.score).to eq(3)
        expect(answered_enquete.request).to eq('おいしかったです。')
        expect(answered_enquete.present_id).to eq(1)

      end
    end
  end

   describe 'アンケート回答時の条件' do

     context 'メールアドレスを確認すること' do
       # 前処理を共通化して「田中太郎」のテストデータを作成する
          before do
            FactoryBot.create(:food_enquete_tanaka)
          end

       it '同じメールアドレスで再び回答できないこと' do
         # テストデータの作成
           
          # 2つ目のテストデータを作成
          re_enquete_tanaka = FactoryBot.build(:food_enquete_tanaka, food_id: 0, score: 1, present_id: 0, request: "スープがぬるかった")
          expect(re_enquete_tanaka).not_to be_valid

          #メールアドレスがすでに存在するメッセージが含まれていることを検証する
          expect(re_enquete_tanaka.errors[:mail]).to include(I18n.t('errors.messages.taken'))
          expect(re_enquete_tanaka.save).to be_falsey
          expect(FoodEnquete.all.size).to eq 1
       end

       it '異なるメールアドレスで回答できること' do
         # beforeで前処理で田中太郎のテストデータを作成しているため:food_enquete_tanakaが作成済みとなる 

          enquete_yamada = FactoryBot.build(:food_enquete_yamada) 

          expect(enquete_yamada).to be_valid
          enquete_yamada.save 
          expect(FoodEnquete.all.size).to eq 2
       end
     end


     context '年齢を確認すること' do
       it '未成年はビール飲み放題選択できないこと' do
         # 未成年のテストデータ作成
          
          enquete_sato = FactoryBot.build(:food_enquete_sato)

          expect(enquete_sato).not_to be_valid
          expect(enquete_sato.errors[:present_id]).to include(I18n.t('activerecord.errors.models.food_enquete.attributes.present_id.cannot_present_to_minor'))
       end

       it '成人はビール飲み放題を選択できる' do
        # 成人のテストデータを作成  
        
        enquete_sato = FactoryBot.build(:food_enquete_sato, age:20)

        expect(enquete_sato).to be_valid
       end


     end
   end

  describe '#adult?' do
    it '20歳未満は成人ではないこと' do
      foodEnquete = FoodEnquete.new
      # 未成年になることを検証する
      expect(foodEnquete.send(:adult?, 19)).to be_falsey
    end
  end

  describe '共通バリデーション' do
    it_behaves_like '入力項目の有無'
    it_behaves_like 'メールアドレスの形式'    
  end

  describe '共通メソッド' do
    # 共通化するテストケースを定義する
    it_behaves_like '価格の表示'
    it_behaves_like '満足度の表示'
  end

end
