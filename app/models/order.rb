class Order < ApplicationRecord

# 今日登録された情報を抽出
scope :created_today, -> { where( "created_at >= ?", Time.zone.now.beginning_of_day)}

has_many :order_items
has_many :items, through: :order_items

belongs_to :client

enum status: { waiting: 0, paid: 1, in_production: 2, preparation: 3, shipped: 4}
enum payment_method:{ credit_card: 0, bank_transfer: 1}

validate :check_order_item_status

def  check_order_item_status
    order_items = self.order_items
    if self.waiting?
        order_items.each do |order_item|
            unless order_item.production_status == :unable
                errors.add(:status, "制作ステータスが着手不可以外なので更新できません")
            end
        end
    elsif self.preparation?
        order_items.each do |order_item|
            unless order_item.production_status == :finish
                errors.add(:status, "製作完了してないので更新できません")
            end
        end
    elsif self.shipped?
        order_items.each do |order_item|
            unless order_item.production_status == :finish
                errors.add(:status, "製作完了していないので更新できません")
            end
        end
    end
end
    # case self.status
    # when :waiting
    #     order_items.each do |order_item|
    #         unless order_item.production_status == :unable
    #             errors.add(:waiting, "更新できません")
    #         end
    #     end
    # when :preparation
#         order_items.each do |order_item|
#             unless order_item.production_status == :finish
#                 errors.add(:waiting, "更新できません")
#             end
#         end
#     when :finish
#         order_items.each do |order_item|
#             unless order_item.production_status == :finish
#                 errors.add(:waiting, "更新できません")
#             end
#         end
#     end
# end

def all_shipping_info
    self.post_number + "    " + self.address + "<br>" + self.receiver
end

def sub_total
    self.total_fee - self.postage
end

end
