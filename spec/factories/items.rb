FactoryBot.define do
  factory :item do
    name {'苺のケーキ'}
    context {'季節の苺を使用した、お店自慢のケーキです。'}
    price {'300'}
    is_sale {'true'}
    genre
  end
end