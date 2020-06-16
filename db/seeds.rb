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
Genre.create(
	name: 'ケーキ',
	is_valid:  true
)

Genre.create(
	name: 'プリン',
	is_valid: true
)


Genre.create(
	name: '焼き菓子',
	is_valid: true
)

Genre.create(
	name: 'キャンディ',
	is_valid: true
)