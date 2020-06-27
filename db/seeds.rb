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

# 最初から追加されているジャンル名
 [ 'ケーキ',
 	'プリン',
 	'焼き菓子',
 	'キャンディ'
 ].each { |genre_name|
 	Genre.create( name: genre_name, is_valid: true)
 }

 1..5.times do |i|
   Client.create(
   email: "test@test.com#{i}",
   password: "testtest",
   first_name: "花子#{i}",
   family_name: "山田#{i}",
   first_name_kana: "ハナコ",
   family_name_kana: "ヤマダ",
   post_number: "00000#{i}",
   address: "大阪府",
   tel: "909009#{i}"
 )
 end

   Item.create(
     name: "cake",
     context: "oisii",
     price: 700,
     genre_id: 2,
     is_sale: true
   )

   Order.create(
     client_id: 1,
     payment_method: 1,
     postage: 800,
     total_fee: 3000,
     address: "京都府",
     post_number: "0909009",
     receiver: "田口"
   )

   OrderItem.create(
     order_id: 2,
     item_id: 2,
     item_count: 2,
     price: 1100,
     )

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
