module CommonOrder
  extend ActiveSupport::Concern

  #-- 定数定義 --#
  POSTAGE = 800
  TAX = 1.08

  #-- 関数定義 --#
  module_function

  # 購入確定時の請求合計金額を計算
  def calc_billing_amount(cart_items)
    # 請求金額
    billing_amount = 0
    # 商品合計金額を加算
    billing_amount += calc_item_total_amount(cart_items) if cart_items
    # 送料を加算
    billing_amount += POSTAGE
  end
  
  # カート内の商品合計金額を計算
  def calc_item_total_amount(cart_items)
    return 0 unless cart_items
    # 購入商品リスト分ループ
    cart_items.inject(0){ |total_amount, cart_item|
      # 商品小計の累計額を算出
      total_amount += calc_subtotal(item_price: cart_item.item.price, item_count: cart_item.item_count)
    }
  end
  
  # 商品小計を計算
  def calc_subtotal(item_price: 0, item_count: 0, tax_included: true)
    return 0 if item_price == 0 || item_count == 0
    # 税別・税込別に計算
    item_amount = (item_price * item_count)
    if tax_included
      (BigDecimal(item_amount.to_s) * BigDecimal(TAX.to_s)).ceil
    else
      BigDecimal(item_amount.to_s).ceil
    end
  end

end