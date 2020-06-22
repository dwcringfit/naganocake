class Client::ItemsController < Client::Base
	skip_before_action  :authenticate_client!

  def index
       @genres = Genre.where(is_valid: true)
    if params[:genre_id]   #もしジャンルIDパラメーターを受け取ったら
       @genre = Genre.find(params[:genre_id]) #該当のジャンルを探してくる
       @items = @genre.items.order(created_at: :desc).all #genre_idと紐づく商品を探してくる。且つ作成順に綺麗に並べる。
    else
      @items = Item.where(genre_id: false) #それ以外は商品すべてを取得
    end
  end


  def show
    @item = Item.find(params[:id])
    @genres = Genre.all
    @cart_item = CartItem.new
  end


end
