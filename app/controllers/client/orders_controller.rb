class Client::OrdersController < Client::Base
  
  def thanks
  end

  def confirm
  end

  def index
    @orders = Order.all
  end

  def new
  end

  def create
  end

  def show
    @order = Order.find(params[:id])
    @order_items = @order.order_items
    @order_price = @order.order_items.find_by(order_id: params[:id])
  end

end
