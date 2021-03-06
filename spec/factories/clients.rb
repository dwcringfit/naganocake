FactoryBot.define do
  factory :client do
    first_name {'山田'}
    family_name {'花子'}
    first_name_kana {'ヤマダ'}
    family_name_kana {'ハナコ'}
    post_number {'1500041'}
    address {'東京都渋谷区神南1丁目19-11 パークスウェースクエア24階'}
    tel {'0368694700'}
    is_valid {'true'}
    email {'hoge@example.com'}
    password {'password'}
  end
  factory :client2, parent: :client do
    family_name {'太郎'}
    family_name_kana {'タロウ'}
    email {'test@example.com'}
  end
  factory :client3, parent: :client do
    first_name {'山下'}
    family_name {'次郎'}
    first_name_kana {'ヤマシタ'}
    family_name_kana {'ジロウ'}
    post_number {'5560023'}
    address {'大阪府大阪市浪速区稲荷'}
    tel {'0879694700'}
    email {'yamasita@example.com'}
  end
end