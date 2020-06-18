class CartItem < ApplicationRecord

	belongs_to :client
    belongs_to :item

    attachment :image

end
