class Order < ApplicationRecord

  has_many :order_items, dependent: :destroy
  has_many :items, through: :order_items

  belongs_to :client

  def all_shipping_info
      self.post_number + self.address + self.receiver
  end

  def sub_total
      self.total_fee - self.postage
  end
  
end
