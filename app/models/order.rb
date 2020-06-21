class Order < ApplicationRecord

  has_many :order_items, dependent: :destroy
  has_many :items, through: :order_items

  belongs_to :client

  # 今日登録された情報を抽出
  scope :created_today, -> { where( "created_at >= ?", Time.zone.now.beginning_of_day)}

  def all_shipping_info
      self.post_number + self.address + self.receiver
  end

  def order_total
      (self.price * self.item_count)
  end
  
end
