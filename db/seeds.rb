# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# 管理者
Admin.create(
  email: 'test@test.com',
  password: 'password'
)

#最初から追加されているジャンル名
[ 'ケーキ',
	'プリン',
	'焼き菓子',
	'キャンディ'
].each { |genre_name|
	Genre.create( name: genre_name, is_valid: true)
}

10.times do |i|
	i += 1
	Client.create(
		email: "test#{i}@test.com",
 		encrypted_password: "testtest#{i}",
    	first_name: "太郎#{i}",
    	family_name: "日本#{i}",
    	first_name_kana: "タロウ#{i}",
    	family_name_kana: "ニホン#{i}",
    	post_number: "999999999#{i}",
    	address: "大阪#{i}",
    	tel: "0900909090#{i}"
	)
end