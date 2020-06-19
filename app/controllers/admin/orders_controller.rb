class Admin::OrdersController < Admin::Base

    def index
        @orders = Order.all
    end

    def show
        @order = Order.find(params[:id])
        @orders = OrderItem.find(params[:id])
    end
end
