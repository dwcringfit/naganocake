class OrderItem < ApplicationRecord

    include CommonOrder

    enum production_status: { unable: 0, wait_for_product: 1, in_production: 2, finish: 3 }

    belongs_to :order
    belongs_to :item

    def subtotal
        CommonOrder.calc_subtotal(item_price: self.price, item_count: self.item_count)
    end

end
