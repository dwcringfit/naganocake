class Client::OrdersController < Client::Base
  before_action :correct_client, only: [:show]

  def confirm
  end

  def index
    @orders = Order.where(client_id: current_client.id)
    # @orders = Order.all
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

private
def correct_client
    @order = Order.find(params[:id])
    unless current_client.id == @order.client_id
      redirect_to orders_path(current_client)
      flash[:alert] = "アクセス権を超えています。あなたの注文履歴に戻りました。"
    end
end

end
