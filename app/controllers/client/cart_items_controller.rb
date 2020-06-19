class Client::CartItemsController < Client::Base
  # 注文共通処理を読込
	include CommonOrder
		
  def index
		@cart_items = current_client.cart_items
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

		   if @item.is_sale
		      @cart_item.save
		      redirect_to cart_items_path
		   else
		      flash[:cartitem_create_error] = "商品が売り切れています。"
		      redirect_to item_path(@item)
		   end
		end
	end

	def update
		cart_item = CartItem.find(params[:item_id])

		if cart_item.update(cart_item_params)
		   redirect_to cart_items_path
		else
		   @cart_items = current_client.cart_items
		   flash[:cartitem_update_error] = "商品数を１以上で選択してください"
           redirect_to cart_items_path
        end
	end

	def destroy
		cart_item = current_client.cart_items.find_by(item_id: params[:item_id])
		cart_item.destroy
		redirect_to cart_items_path
	end

	def destroy_all
		@cart_items = current_client.cart_items
		@cart_items.destroy_all
		redirect_to cart_items_path
	end

	private

	    def cart_item_params
		    params.require(:cart_item).permit(:item_id, :item_count)
	    end
end
