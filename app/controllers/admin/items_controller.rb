class Admin::ItemsController < Admin::Base


    def index
	  @items = Item.all
    end


    def new
	  @item = Item.new
    end


    def create
	  @item = Item.new(item_params)
	  if @item.save
		  redirect_to @item
	  else
		  render "new"
	  end
    end


    def show
    	@item = Item.find(params[:id])
    	@item_taxin = item.price * 1.08
    end


    def edit
	  @item = Item.find(params[:id])
    end


    def update
	  @item = Item.find(params[:id])
	  if @item.update(item_params)
	     redirect_to @item
	  else
	  	 render 'edit'
	  end
    end



private

  def item_params
  	params.require(:item).permit(:name,:context,:image_id,:genre_id,:price,:is_sale)
  end

end
