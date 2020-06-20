class Admin::TopController < Admin::Base
  def top
    @orders = Order.created_today
  end
end
