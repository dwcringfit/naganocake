class CartItem < ApplicationRecord
    # 注文共通処理を読込
    include CommonOrder

	belongs_to :client
    belongs_to :item

    # validates :item_count, presence: true, numericality: { greater_than: 0 }

    # 商品小計を取得
    def subtotal
        CommonOrder.calc_subtotal(item_price: self.item.price, item_count: self.item_count)
    end
    
end
