class CartItem < ApplicationRecord
    # 注文共通処理を読込
    include CommonOrder

	belongs_to :client
    belongs_to :item

    validates :item_count, presence: true, numericality: { greater_than: 0 }
    validate :check_item_sale

    # 商品小計を取得
    def subtotal
        CommonOrder.calc_subtotal(item_price: self.item.price, item_count: self.item_count).to_s(:delimited)
    end

    def check_item_sale
    	unless self.item.is_sale
            errors.add(:item_id, "売り切れのため購入できません。")
    	end
    end
end
