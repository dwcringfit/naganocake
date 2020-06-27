class Client::TopController < Client::Base
  def top
  	   @genres = Genre.where(is_valid: true)
    if params[:genre_id]   #もしジャンルIDパラメーターを受け取ったら
       @genre = Genre.find(params[:genre_id]) #該当のジャンルを探してくる
       @items = @genre.items.order(created_at: :desc).all #genre_idと紐づく商品を探してくる。且つ作成順に綺麗に並べる。
    else
       @items = Item.all #それ以外は商品すべてを取得
    end
    @items_recommend = Item.recommend_list
    if @items_recommend.count == 0
    	@items_recommend = Item.all.limit(4)
    end
  end


end
