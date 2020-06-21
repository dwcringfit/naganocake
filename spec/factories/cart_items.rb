FactoryBot.define do
  factory :cart_item do
    item_count {'1'}
    client
    item
  end
end