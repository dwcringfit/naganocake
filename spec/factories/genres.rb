FactoryBot.define do
  factory :genre do
    name {'ケーキ'}
    is_valid {'true'}
  end
  factory :genre2, parent: :genre do
    name {'プリン'}
  end
end