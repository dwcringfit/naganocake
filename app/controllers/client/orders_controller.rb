class Client::OrdersController < Client::Base
  # 注文共通処理を読込
  include CommonOrder
  
  def thanks
  end

  def confirm
    # カート内の商品合計金額を算出
    @total_fee = CommonOrder.calc_billing_amount(cart_items)
    # 住所を選択
    @order = current_client.orders.new(set_order)
    # case文による条件分岐を行う
    case params[:addressee]
    when "ご自身の住所"
      @order.address = current_client.address
      @order.post_number = current_client.post_number
      @order.receiver = current_client.first_name + current_client.family_name
    when "登録済住所から選択"
      @order.address = Delivery.find(delivery[:id]).address
      @order.post_number = Delivery.find(delivery[:id]).post_number
      @order.receiver = Delivery.find(delivery[:id]).receiver
    when "新しいお届け先"
    end
  end

  def index
    @orders = Order.all
  end

  def new
    @order = Order.new
    @delivery = Delivery.new
  end

  def create
    @order = current_client.orders.new(set_order)
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

  def show
    @order = Order.find(params[:id])
    @order_items = @order.order_items
    @order_price = @order.order_items.find_by(order_id: params[:id])
  end

  private
  def set_order
    params.require(:order).permit(:payment_method, :address, :post_number, :receiver)
  end
  def set_delivery
    params.require(:order).require(:delivery).permit(:id)
  end
end
end
