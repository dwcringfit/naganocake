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
        @order.update.(order_params)
        redirect_to admin_order_path
    end

    #未完
    # private
    # def order_params
    #     params.require(:order).permit(:status)
    # end
        
    # def order_item_params
    #     params.require(:order_item).permit(:production_status)
    # end

end
