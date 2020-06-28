class Client::OrdersController < Client::Base
  before_action :correct_client, only: [:show]
  # 注文共通処理を読込
  include CommonOrder

  def thanks
  end

  def confirm
    # カート内の商品合計金額を計算
    @cart_total_fee = CommonOrder.calc_item_total_amount(current_client.cart_items)
    # 住所を選択
    @order = current_client.orders.new(set_order)
    @order.postage = CommonOrder::POSTAGE
    # 購入確定時の請求合計金額を計算
    @order.total_fee = CommonOrder.calc_billing_amount(current_client.cart_items)
    # case文で住所選択の条件分岐を行う
    case params[:address]
    when "ご自身の住所"
      @order.address = current_client.address
      @order.post_number = current_client.post_number
      @order.receiver = current_client.first_name + current_client.family_name
    when "登録済住所から選択"
      @order.address = current_client.deliveries.find(params[:delivery_id]).address
      @order.post_number = current_client.deliveries.find(params[:delivery_id]).post_number
      @order.receiver = current_client.deliveries.find(params[:delivery_id]).receiver
    when "新しいお届け先"
    end

    unless @order.valid?
      @delivery = Delivery.new
      render :new
    end


  end

  def index
    @orders = Order.where(client_id: current_client.id).page(params[:page]).per(5).order(created_at: :desc)
    # current_client.orders
  end

  def new
    @order = Order.new
    @delivery = Delivery.new
  end

  def create
    @order = current_client.orders.new(set_order)
    @order.postage = CommonOrder::POSTAGE
    if @order.save!
      current_client.cart_items.each do |cart_item|
        # 注文商品テーブルにレコードを追加する
        @order_items = OrderItem.new(
          item_id: cart_item.item_id,
          item_count: cart_item.item_count,
          price: CommonOrder.calc_item_total_amount(@cart_items),
          order_id: @order.id)
          @order_items.save!
        end
        Delivery.create!(
          client_id: current_client.id,
          post_number: @order.post_number,
          address: @order.address,
          receiver: @order.receiver)
        current_client.cart_items.destroy_all
    end
    redirect_to thanks_orders_path
  end

  def update
    @order = Order.find(params[:id])
    @oreder.update(status_params)
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
      redirect_to root_path
    end
  end

  def set_order
    params.require(:order).permit(:total_fee, :payment_method, :address, :post_number, :receiver)
  end

  def set_delivery
    params.require(:order).require(:delivery).permit(:id)
  end

  def status_params
    params.require(:order).permit(:status)
  end
end
