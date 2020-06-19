class Admin::OrdersController < Admin::Base

    def index
        @orders = Order.all
    end

    def show
        @order = Order.find(params[:id])
        @orders = OrderItem.find(params[:id])
    end

    def update
        @order = Order.find(params[:id])
        @order.update.(order_params)
        redirect_to admin_order_path
    end

    private
    def order_params
        params.require(:order).permit(:status)
        params.require(:order_item).permit(:production_status)
    end
end
