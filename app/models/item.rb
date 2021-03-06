class Item < ApplicationRecord

	has_many :order_items
	has_many :orders, through: :order_items
	has_many :cart_items, dependent: :destroy
	has_many :clients, through: :cart_item, dependent: :destroy


	belongs_to :genre

	validates :name, presence: true, uniqueness: true
	validates :context, presence: true
	validates :price, presence: true, numericality: { only_integer: true,
    greater_than: 0 }
	validates :is_sale, inclusion: { in: [true, false] }

	attachment :image

	# 税込価格を取得
	def price_tax_included(tax: 1.08)
		# 商品価格が0円の場合
		return self.price if self.price == 0
		# 税込計算
		(BigDecimal(self.price.to_s) * BigDecimal(tax.to_s)).ceil
	end

	# 販売ステータス名称を取得
	def sale_status_name
		self.is_sale ? "販売中" : "売り切れ"
	end

	# 検索結果を取得
	def self.search(search_word)
		@items = Item.where(['name LIKE?', "%#{search_word}%"])
	end

end
