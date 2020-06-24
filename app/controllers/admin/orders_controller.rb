class Admin::OrdersController < Admin::Base

    def index
        @orders = Order.all
    end

    def show
        @order = Order.find(params[:id])
        @order_items = @order.order_items
        @order_price = @order.order_items.find_by(order_id: params[:id])
    end


    def update
        @order = Order.find(params[:id])
        if @order.update_attributes(order_params)
            redirect_to admin_order_path
        else
            @order_items = @order.order_items
            render 'show'
        end
    end

    private
    def order_params
        params.require(:order).permit(:status)
    end

end
