require 'rails_helper'

RSpec.describe "登録から注文(ECサイト)", type: :system do
  
  let!(:client) { create :client }
  let!(:genre) { create :genre }
  let!(:item) { create :item, genre: genre }
  let!(:genre2) { create :genre2 }
  let!(:item2) { create :item2, genre: genre2 }
  let!(:delivery) { create :delivery, client: client }

  before do |login|
    unless login.metadata[:skip_login]
      visit new_client_session_path
      fill_in "client[email]",	with: client.email
      fill_in "client[password]",	with: client.password
      click_button "ログイン"
    end
  end

  describe "ECサイトの会員登録", :skip_login do
    let!(:new_client) { build :client2}
    before { visit root_path }

    context "画面遷移" do
      it "会員ECサイトのトップ画面から新規登録画面へ遷移できること" do
        click_on "新規登録"
        expect(current_path).to eq new_client_registration_path
      end
    end
    
    context "新規アカウント登録" do
      before do
        within "header" do
          click_link "新規登録"
        end
        fill_in "client[first_name]",	with: new_client.first_name
        fill_in "client[family_name]",	with: new_client.family_name
        fill_in "client[first_name_kana]",	with: new_client.first_name_kana
        fill_in "client[family_name_kana]",	with: new_client.family_name_kana
        fill_in "client[email]",	with: new_client.email
        fill_in "client[post_number]",	with: new_client.post_number
        fill_in "client[address]",	with: new_client.address
        fill_in "client[tel]",	with: new_client.tel
        fill_in "client[password]",	with: new_client.password
        fill_in "client[password_confirmation]",	with: new_client.password
        click_button "新規登録"
      end
      it "新規登録した会員が問題なく登録できていること" do
        @client_db = Client.find_by(email: new_client.email)
        expect(new_client.email).to eq @client_db.email 
      end
      it "アカウント登録後にトップ画面へ遷移していること" do expect(current_path).to eq root_path end
      it "アカウント登録完了メッセージが表示されていること" do expect(page).to have_content "アカウント登録が完了" end
    end
  end

  describe "商品の選択とカート追加" do
    context "トップ画面から任意の商品画像を選択" do
      before { first("a[href='#{item_path(item)}']").click }
      it "選択した商品詳細画面へ遷移していること" do expect(current_path).to eq item_path(item) end
      it "選択した商品情報が正しく詳細画面に表示されていること" do
        expect(page.find("tbody")).to have_content item.genre.name
        expect(page).to have_content item.name
        expect(page).to have_content item.context
        expect(page).to have_content item.price
      end
    end
    context "トップ画面から該当商品(1個目)を選択してカートに追加" do
      before do
        first("a[href='#{item_path(item)}']").click
        select 4, from: "cart_item[item_count]"
        click_on "カートに入れる"
      end
      it "カートに入れるボタン押下でカート画面へ遷移していること" do
        expect(current_path).to eq cart_items_path
        expect(page).to have_content "ショッピングカート"
      end
      it "カートに入れた商品情報が正しく画面にて表示されていること" do
        @cart_item = CartItem.find_by(item_id: item.id, client_id: client.id)
        within "tbody" do
          expect(page).to have_content @cart_item.item.name
          expect(page).to have_content @cart_item.item.price_tax_included
          have_field "cart_item[item_count]", with: @cart_item.item_count 
          expect(page).to have_content @cart_item.subtotal
        end
      end
      it "買い物を続けるボタン押下でトップ画面へ遷移していること" do
        click_on "買い物を続ける"
        expect(current_path).to eq root_path
      end      
    end
    context "商品一覧から該当商品(2個目)を選択してカートに追加" do
      let!(:cart_item1) { create :cart_item, client: client, item: item, item_count: 4}
      before do
        click_link "商品一覧"
        first("a[href='#{item_path(item2)}']").click
        select 2, from: "cart_item[item_count]"
        click_on "カートに入れる"
      end
      it "カートに入れるボタン押下でカート画面へ遷移していること" do
        expect(current_path).to eq cart_items_path
        expect(page).to have_content "ショッピングカート"
      end
      it "カートに入れた商品情報が正しく画面にて表示されていること" do
        @cart_item2 = CartItem.find_by(item_id: item2.id, client_id: client.id)
        within "tbody" do
          expect(page).to have_content @cart_item2.item.name
          expect(page).to have_content @cart_item2.item.price_tax_included
          have_field "cart_item[item_count]", with: @cart_item2.item_count 
          expect(page).to have_content @cart_item2.subtotal
        end
      end
      it "合計金額が正しく表示されていること" do
        expect(page).to have_content client.cart_items.inject(0){ |total,cart_item| total += cart_item.subtotal }
      end
      it "情報入力に進むボタン押下で注文情報入力画面へ遷移していること" do
        click_on "情報入力に進む"
        expect(current_path).to eq new_order_path
      end      
    end
  end
  
  describe "注文情報の入力から注文確定" do
    let!(:cart_item1) { create :cart_item, client: client, item: item, item_count: 4}
    let!(:cart_item2) { create :cart_item, client: client, item: item2, item_count: 2}
    before do
      visit cart_items_path
      click_on "情報入力に進む"
    end
    context "注文情報入力画面を表示" do
      it "支払方法が正しく表示されていること" do
        expect(page).to have_checked_field "order[payment_method]", with: "credit_card"
        expect(page).to have_unchecked_field "order[payment_method]", with: "bank_transfer"
      end
      it "お届け先が正しく表示されていること" do
        expect(page).to have_checked_field "address", with: "ご自身の住所"
        expect(page).to have_unchecked_field "address", with: "登録済住所から選択"
        expect(page).to have_unchecked_field "address", with: "新しいお届け先"
        expect(page).to have_content client.post_number
        expect(page).to have_content client.address
        expect(page).to have_content client.get_full_name
        expect(page).to have_select( "delivery_id", options: ["#{delivery.post_number} #{delivery.address} #{delivery.receiver}"])
      end
    end
    context "注文内容確認画面を表示" do
      before do
        find("input[name='order[payment_method]'][value='credit_card']").set(true)
        find("input[name='address'][value='ご自身の住所']").set(true)
        click_on "確認画面へ進む"
        @cart_items = client.cart_items
      end
      it "確認画面へ進むボタン押下で注文確認画面へ遷移していること" do expect(current_path).to eq confirm_orders_path end
      it "カート商品の内容が正しく表示されていること" do
        @cart_items.each do |cart_item|
          expect(page).to have_content cart_item.item.name
          expect(page).to have_content cart_item.item.price_tax_included
          expect(page).to have_content cart_item.item_count
          expect(page).to have_content cart_item.subtotal
        end
      end
      it "送料・商品合計・請求金額が正しく表示されていること" do
        # 送料
        expect(page).to have_content 800
        # 商品合計金額
        @total_item_price = @cart_items.inject(0){|total,cart_item| total += cart_item.subtotal}
        expect(page).to have_content @total_item_price
        # 請求合計金額
        expect(page).to have_content (@total_item_price + 800)
      end
      it "購入を確定するボタン押下で注文情報が登録されていること" do
        expect{ click_on "購入を確定する" }.to change{ client.orders.count }.by(1)
      end
      it "購入を確定するボタン押下でサンクスページへ遷移していること" do
        click_on "購入を確定する"
        expect(page).to have_content "ご購入ありがとうございました"
      end
      it "サンクスページからマイページへ画面遷移できること" do
        click_on "購入を確定する"
        click_link "マイページ"
        expect(current_path).to eq client_path(client)
      end
    end
  end

  describe "注文履歴画面で注文内容を確認" do
    let!(:cart_item1) { create :cart_item, client: client, item: item, item_count: 4}
    let!(:cart_item2) { create :cart_item, client: client, item: item2, item_count: 2}
    before do
      # 一連の注文処理を再現
      visit cart_items_path
      click_on "情報入力に進む"
      find("input[name='order[payment_method]'][value='credit_card']").set(true)
      find("input[name='address'][value='ご自身の住所']").set(true)
      click_on "確認画面へ進む"
      click_on "購入を確定する"
      click_on "マイページ"
      first("a[href='#{orders_path}']").click
    end
    context "注文履歴一覧画面を表示" do
      it "マイページから注文履歴一覧へ遷移できること" do expect(current_path).to eq orders_path end
      it "注文履歴一覧の内容が正しく表示されていること" do
        @orders = client.orders
        @orders.each do |order|
          expect(page).to have_content order.created_at.strftime('%Y/%m/%d')
          expect(page).to have_content order.post_number
          expect(page).to have_content order.address
          expect(page).to have_content order.receiver
          expect(page).to have_content order.total_fee
          expect(page).to have_content "入金待ち"
          # すべての注文商品名
          order.order_items.each do |order_item|
            expect(page).to have_content order_item.item.name
          end
        end
      end
    end
    context "注文履歴詳細画面を表示" do
      before do
        @order = client.orders.first
        first("a[href='#{order_path(@order)}']").click
      end
      it "注文履歴一覧から注文履歴詳細画面へ遷移できること" do expect(current_path).to eq order_path(@order) end
      it "注文情報が正しく表示されていること" do
        expect(page).to have_content @order.created_at.strftime('%Y/%m/%d')
        expect(page).to have_content @order.post_number
        expect(page).to have_content @order.address
        expect(page).to have_content @order.receiver
        expect(page).to have_content @order.payment_method_i18n
        expect(page).to have_content "入金待ち"
      end
      it "請求情報が正しく表示されていること" do
        expect(page).to have_content (@order.total_fee -  @order.postage)
        expect(page).to have_content @order.postage
        expect(page).to have_content @order.total_fee
      end
      it "注文内容が正しく表示されていること" do
        within "tbody" do
          @order.order_items.each do |order_item|
            expect(page).to have_content order_item.item.name
            expect(page).to have_content order_item.price
            expect(page).to have_content order_item.item_count
            expect(page).to have_content order_item.subtotal
          end
        end
      end
    end
  end
end
