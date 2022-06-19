FactoryBot.define do
  factory :food_enquete do

    # ==========ここから追加する==========
    name { '田中 太郎' }
    mail { 'taro.tanaka@example.com' }
    age { 25 }
    food_id { 2 }
    score { 3 }
    request { 'おいしかったです。' }
    present_id { 1 }
    # ==========ここまで追加する==========

  end
end
