class Item < ApplicationRecord

	has_many :cart_items
	has_many :order_items

	belongs_to :genre

	validates :name, presence: true
	validates :context, presence: true
	validates :price, presence: true

    attachment :image


end
