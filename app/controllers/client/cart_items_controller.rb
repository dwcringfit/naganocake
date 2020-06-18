class Client::CartItemsController < Client::Base

    def index
		@cart_items = current_client.cart_items
	end

	def create
		@item = Item.find(params[:cart_item][:item_id])
		@cart_item = CartItem.new(cart_item_params)
		@cart_item.client_id = current_client.id
		@cart_item.item_id = @item.id

		if @item.is_sale == true
		   @cart_item.save
		   redirect_to cart_items_path
		else
		   @item = Item.find(params[:cart_item][:item_id])
           @genres = Genre.all
           @cart_item = CartItem.new
		   render "client/items/show"
		end
	end

	def update
	end

	def destroy
	end

	def destroy_all
	end

	private

	    def cart_item_params
		    params.require(:cart_item).permit(:item_id, :item_count)
	    end
end
