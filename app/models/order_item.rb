class OrderItem < ApplicationRecord

    include CommonOrder

    belongs_to :order
    belongs_to :item

    def subtotal
        CommonOrder.calc_subtotal(item_price: self.price, item_count: self.item_count)
    end

    # def subtotal
    #     itemprice = self.price * 1.08
    #     (itemprice * self.item_count).to_i
    # end

end
