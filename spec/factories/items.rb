FactoryBot.define do
  factory :item do
    name {'苺のケーキ'}
    context {'季節の苺を使用した、お店自慢のケーキです。'}
    price {'800'}
    is_sale {'true'}
    genre
  end
  factory :item2, parent: :item do
    name {'苺のプリン'}
    context {'季節の苺を使用した、お店自慢のプリンです。'}
    price {'600'}
  end
end