FactoryBot.define do
  factory :order_item do
    item_count {'4'}
    price { '800' }
    production_status {0}
    order
    item
  end
  factory :order_item2, parent: :order_item do
    item_count {'2'}
    price { '600' }
  end
end
