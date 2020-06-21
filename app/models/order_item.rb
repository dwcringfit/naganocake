class OrderItem < ApplicationRecord

    include CommonOrder

    belongs_to :order
    belongs_to :item

    def subtotal
        CommonOrder.calc_subtotal(item_price: self.item.price, item_count: self.item_count)
    end
end
