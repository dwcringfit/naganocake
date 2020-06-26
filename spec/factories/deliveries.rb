FactoryBot.define do
  factory :delivery do
    post_number {'4001114'}
    address {'山梨県甲斐市打返 4-5-19'}
    receiver {'小沢時男'}
    client
  end
  factory :delivery2, parent: :delivery do
    post_number {'2440812'}
    address {'神奈川県横浜市戸塚区柏尾町3-9-10'}
    receiver {'梅木匠'}
  end
end