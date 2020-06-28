class Admin::OrdersController < Admin::Base

    protect_from_forgery

    def index
        case params[:order]
        when 'today'
            @orders = Order.created_today.page(params[:page]).per(10).order(created_at: :desc)
        when 'all'
            @orders = Order.page(params[:page]).per(10).order(created_at: :desc)
        end
    end

    def show
        @order = Order.find(params[:id])
        @order_items = @order.order_items
    end


    def update
        @order = Order.find(params[:id])
        if @order.update(order_params)
            if @order.paid?
                OrderItem.where(order_id: @order.id).update_all(production_status: :wait_for_product)
            end
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

end
