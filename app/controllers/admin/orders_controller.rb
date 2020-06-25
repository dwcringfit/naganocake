class Admin::OrdersController < Admin::Base

    protect_from_forgery

    def index
        @orders = Order.all
    end

    def show
        @order = Order.find(params[:id])
        @order_items = @order.order_items
        @order_price = @order.order_items.find_by(order_id: current_client.id)
    end


    def update
        @order = Order.find(params[:id])
        # @orderitem = OrderItem.where(params[:id]: order_id)
        if @order.update_attributes(order_params)
            # case @order.status
            # when "入金確認"
            #     @orderitem.production_status = "製作待ち"
            #     @orderitem.update(pro_status_params)
            # end
            redirect_to admin_order_path(@order)
        else
            @order_items = @order.order_items
            render 'show'
        end
    end

    private
    def order_params
        params.permit(:status)
    end

    def pro_status_params
        params.(:order_item).permit(:production_status)
    end
end
