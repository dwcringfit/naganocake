FactoryBot.define do
  factory :order do
    status {'0'}
    payment_method {'0'}
    postage {'800'}
    total_fee {'1200'}
    address {'東京都渋谷区神南1丁目19-11 パークスウェースクエア24階'}
    post_number {'1500041'}
    receiver {'山田花子'}
    client
  end
end