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
        @orderitem = OrderItem.where(order_id: @order.id)
        if @order.update_attributes(order_params)
            if @order.paid?
                OrderItem.where(order_id: @order.id).update_all(production_status: :wait_for_product)
            end
            redirect_to admin_order_path(@order)
            # case @order.status
            # when @order.paid?
            #     OrderItem.where(order_id: @order.id).update_all(production_status: :wait_for_production)
            # end
            # redirect_to admin_order_path(@order)
        else
            @order_items = @order.order_items
            render 'show'
        end
    end

    private
    def order_params
        params.permit(:status)
    end

end
