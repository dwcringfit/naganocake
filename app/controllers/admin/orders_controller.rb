class Admin::OrdersController < Admin::Base

    def index
        @orders = Order.all
    end

    def show

    end
end
