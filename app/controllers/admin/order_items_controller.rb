class Admin::OrderItemsController < ApplicationController

    def update
        @order_item = OrderItem.find(params[:id])
        if @order_item.update_attributes(order_item_params)
            if @order_item.in_production?
                Order.where(id: @order_item.id).update_all(status: :in_production)
            else @order_item.finish?
                Order.where(id: @order_item.id).update_all(status: :shipped)
            end
            redirect_to admin_order_path(@order_item.order)
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
