FactoryBot.define do
  factory :delivery do
    post_number {'4001114'}
    address {'山梨県甲斐市打返 4-5-19'}
    receiver {'小沢時男'}
    client
  end
end