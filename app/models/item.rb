class Item < ApplicationRecord

	has_many :cart_items
	has_many :order_items

	belongs_to :genre

	validates :name, presence: true
	validates :context, presence: true
	validates :price, presence: true

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
	
	
end
