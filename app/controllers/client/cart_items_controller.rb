class Client::CartItemsController < Client::Base
  # 注文共通処理を読込
	include CommonOrder

	   before_action :set_cart_items, only:[:index, :destroy_all, :update]
	   before_action :set_item_total_amount, only:[:index, :update]

    def index
	end

	def create
		@item = Item.find(params[:cart_item][:item_id])
		@cart_item = current_client.cart_items.find_by(item_id: params[:cart_item][:item_id])
		if @cart_item
		   @cart_item.item_count += params[:cart_item][:item_count].to_i
		   @cart_item.save
		    redirect_to cart_items_path
		else
		   @cart_item = CartItem.new(cart_item_params)
		   @cart_item.client_id = current_client.id
		   @cart_item.item_id = @item.id

		   if @cart_item.save
		      redirect_to cart_items_path
		   else
		   	  @item = Item.find(params[:cart_item][:item_id])
              @genres = Genre.all
		      render template: "client/items/show"
		   end
		end
	end

	def update
		@cart_item = CartItem.find(params[:item_id])

		if @cart_item.update(cart_item_params)
		   redirect_to cart_items_path
		else
		   render "index"
        end
	end

	def destroy
		cart_item = current_client.cart_items.find_by(item_id: params[:item_id])
		cart_item.destroy
		redirect_to cart_items_path
	end

	def destroy_all
		@cart_items.destroy_all
		redirect_to cart_items_path
	end

	private

	    def cart_item_params
		    params.require(:cart_item).permit(:item_id, :item_count)
	    end

	    def set_cart_items
	    	@cart_items = current_client.cart_items
	    end

	    def set_item_total_amount
	    	@item_total_amount = CommonOrder.calc_item_total_amount(@cart_items).to_s(:delimited)
	    end
end
