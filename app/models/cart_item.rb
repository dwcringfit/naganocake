class CartItem < ApplicationRecord

	belongs_to :client
    belongs_to :item

    validates :item_count, presence: true, numericality: { greater_than: 1 }

end
