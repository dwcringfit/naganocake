class Delivery < ApplicationRecord
    validates :post_number, presence: true, format: {with: /\A[0-9]{3}[0-9]{4}\z/}
    validates :address, presence: true, length: {maximum:250}
    validates :reciver, presence: true
    belong_to :client
end
