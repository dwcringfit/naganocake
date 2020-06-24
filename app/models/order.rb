class Order < ApplicationRecord

# 今日登録された情報を抽出
scope :created_today, -> { where( "created_at >= ?", Time.zone.now.beginning_of_day)}

enum status: { waiting: 0, paid: 1, in_production: 2, preparation: 3, shipped: 4}

has_many :order_items
has_many :items, through: :order_items

belongs_to :client

enum payment_method:{ credit_card: 0, bank_transfer: 1}

def all_shipping_info
    self.post_number + self.address + self.receiver
end

def sub_total
    self.total_fee - self.postage
end

end
