class Delivery < ApplicationRecord
    validates :post_number, presence: true
    validates :address, presence: true, length: {maximum:250}
    validates :receiver, presence: true
    belongs_to :client
end
