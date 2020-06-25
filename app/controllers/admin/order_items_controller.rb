class Admin::OrderItemsController < ApplicationController

    def update
        @order_item = OrderItem.find(params[:id])
        if @order_item.update_attributes(order_item_params)
            @order = Order.find(params[:order_id])
            finish_count = 0
            @order.order_items.each do |order_item|
                if order_item.in_production?
                    @order.update(status: :in_production)
                    break
                elsif order_item.finish?
                    finish_count += 1
                end
            end
            if @order.order_items.count == finish_count
                @order.update(status: :preparation) 
            end
                redirect_to admin_order_path(@order)
        else
            @order = Order.find(params[:id])
            @order_items = @order.order_items
            render template: 'admin/orders/show'
        end
    end

    private
    def order_item_params
        params.require(:order_item).permit(:production_status)
    end
end
