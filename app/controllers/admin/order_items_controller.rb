class Admin::OrderItemsController < ApplicationController

    def update

    end

    private
    def order_item_params
        params.require(:order_item).permit(:production_status)
    end
end
