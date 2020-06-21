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

# # #最初から追加されているジャンル名
[ 'ケーキ',
	'プリン',
	'焼き菓子',
	'キャンディ'
].each { |genre_name|
	Genre.create( name: genre_name, is_valid: true)
}


# 1..10.times do |i|
# 	Client.create(
# 		email: "test#{i}@test.com",
#  		password: "testtest#{i}",
#     	first_name: "太郎#{i}",
#     	family_name: "日本#{i}",
#     	first_name_kana: "タロウ#{i}",
#     	family_name_kana: "ニホン#{i}",
#     	post_number: "999999999#{i}",
#     	address: "大阪#{i}",
#     	tel: "0900909090#{i}"
# 	)
# end

	# 1..10.times do |i|
# 	Order.create!(
# 		client_id: 1,
# 		status: 2,
# 		payment_method: 2,
# 		postage: 800,
# 		total_fee: 1000,
# 		address: "配送先住所",
# 		post_number: "配送先郵便番号",
# 		receiver: "宛名"
# 	)
# 	# end
 
# 	# 1..10.times do |i|
# 	Item.create!(
		# genre_id: 1,
# 		name: "cake",
# 		context: "caption",
# 		price: 900,
# 		is_sale: true
# 	)
# # end
	
# OrderItem.create!(
		# order_id: 1,
		# item_id: 1,
# 		item_count: 2,
# 		price: 700,
# 		production_status: true
# 	)

Client.create(
	is_valid: "true",
    first_name: "清水",
    family_name: "光治",
    first_name_kana: "シミズ",
    family_name_kana: "ミツハル",
    tel: "00000000000",
    email: "m.s@mail",
	password: "000000",
	post_number: "0000000",
	address: "大阪府大阪市北区",
)

Delivery.create(
  client_id: 1,
  receiver: "清水光治",
	post_number: "0000000",
	address: "大阪府大阪市北区",
)