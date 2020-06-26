require 'rails_helper'

RSpec.describe "登録情報変更から退会", type: :system do

  let!(:client) { create :client }
  let!(:genre) { create :genre }
  let!(:item) { create :item, genre: genre }
  let!(:genre2) { create :genre2 }
  let!(:item2) { create :item2, genre: genre2 }
  let!(:delivery) { create :delivery, client: client }

  before do
    visit new_client_session_path
    fill_in "client[email]",	with: client.email
    fill_in "client[password]",	with: client.password
    click_button "ログイン"
  end

  describe "ECサイト（会員情報）" do
    let!(:new_client) { build :client3}
    before do
      click_on "マイページ"
    end

    context "会員情報編集画面" do
      before do
        click_on "編集する"
        fill_in "client[first_name]",	with: new_client.first_name
        fill_in "client[family_name]",	with: new_client.family_name
        fill_in "client[first_name_kana]",	with: new_client.first_name_kana
        fill_in "client[family_name_kana]",	with: new_client.family_name_kana
        fill_in "client[email]",	with: new_client.email
        fill_in "client[post_number]",	with: new_client.post_number
        fill_in "client[address]",	with: new_client.address
        fill_in "client[tel]",	with: new_client.tel
      end
      it "マイページから会員情報編集画面へ遷移できること" do
        expect(current_path).to eq edit_client_path(client)
      end
      it "会員情報が正しく更新できていること" do
        click_button "編集内容を保存する"
        expect(page).to have_content new_client.first_name
        expect(page).to have_content new_client.family_name
        expect(page).to have_content new_client.first_name_kana
        expect(page).to have_content new_client.family_name_kana
        expect(page).to have_content new_client.email
        expect(page).to have_content new_client.post_number
        expect(page).to have_content new_client.address
        expect(page).to have_content new_client.tel
      end
      it "会員情報の編集後はマイページへ遷移していること" do
        click_button "編集内容を保存する"
        expect(current_path).to eq client_path(client)
      end
    end
    
    context "配送先編集画面" do
      let!(:new_delivery) { build :delivery2, client: client }
      before do
        first("a[href='#{deliveries_path}']").click
      end
      it "マイページから配送先一覧画面遷移できること" do
        expect(current_path).to eq deliveries_path
      end
      it "新規登録した配送先が一覧画面に表示されていること" do
        fill_in "delivery[post_number]",	with: new_delivery.post_number
        fill_in "delivery[address]",	with: new_delivery.address
        fill_in "delivery[receiver]",	with: new_delivery.receiver
        click_on "登録する"
        within "tbody" do
          expect(page).to have_content new_delivery.post_number
          expect(page).to have_content new_delivery.address
          expect(page).to have_content new_delivery.receiver
        end
      end
      it "削除後の配送先が一覧画面に表示されていないこと" do
        click_on "削除する", match: :first
        within "tbody" do
          expect(page).to have_no_content delivery.post_number
          expect(page).to have_no_content delivery.address
          expect(page).to have_no_content delivery.receiver
        end
      end
      it "トップ画面へ遷移できること" do
        first("a[href='#{root_path}']").click
        expect(current_path).to eq root_path
      end
    end

    context "商品選択からカート追加" do
      before do
        click_on "商品一覧"
      end
      it "指定したジャンルに紐付く商品が表示されていること" do
        click_on genre.name
        genre.items.each do |item|
          expect(page).to have_content item.name
        end
      end
      it "商品一覧から選択した商品の詳細画面へ遷移できていること" do
        first("a[href='#{item_path(item)}']").click
        expect(current_path).to eq item_path(item)
      end
      it "選択商品の詳細情報が正しく表示されていること" do
        first("a[href='#{item_path(item)}']").click
        expect(page).to have_content item.name
        expect(page).to have_content item.context
        expect(page).to have_content item.price_tax_included
      end
      it "商品一覧から選択した商品がカート内に追加できていること" do
        first("a[href='#{item_path(item)}']").click
        select 4, from: "cart_item[item_count]"
        expect{ click_on "カートに入れる" }.to change{ client.cart_items.count }.by(1)
      end
      it "カート一覧に追加商品が正しく表示されていること" do
        first("a[href='#{item_path(item)}']").click
        select 4, from: "cart_item[item_count]"
        click_on "カートに入れる"
        @cart_items = client.cart_items
        within "tbody" do
          @cart_items.each do |cart_item|
            expect(page).to have_content cart_item.item.name
            expect(page).to have_content cart_item.item.price_tax_included
            have_field "cart_item[item_count]", with: cart_item.item_count 
            expect(page).to have_content cart_item.subtotal
          end
        end
      end
    end
    context "カート画面から注文決済" do
      let!(:cart_item1) { create :cart_item, client: client, item: item, item_count: 4}
      let!(:cart_item2) { create :cart_item, client: client, item: item2, item_count: 2}
      let!(:new_delivery) { create :delivery2, client: client }
      let!(:other_delivery) {build :delivery, client: client, post_number: "9111333", address: "東京都新宿区", receiver: "テスト太郎"}
      before do
        visit cart_items_path
        click_on "情報入力に進む"
        fill_in "order[post_number]",	with: other_delivery.post_number
        fill_in "order[address]",	with: other_delivery.address
        fill_in "order[receiver]",	with: other_delivery.receiver
      end
      it "登録した配送先住所が選択可能になっていること" do
        expect(page).to have_select( "delivery_id", text: "#{new_delivery.post_number} #{new_delivery.address} #{new_delivery.receiver}")
      end
      it "パターン1:銀行振込及び登録配送先住所を選択して注文確認画面へ遷移できること" do
        find("#order_payment_method_bank_transfer").click
        select "#{new_delivery.post_number} #{new_delivery.address} #{new_delivery.receiver}", from: "delivery_id"
        click_on "確認画面へ進む"
        expect(current_path).to eq confirm_orders_path
      end
      it "パターン1:注文確認画面から購入確定できること" do
        find("#order_payment_method_bank_transfer").click
        select "#{new_delivery.post_number} #{new_delivery.address} #{new_delivery.receiver}", from: "delivery_id"
        click_on "確認画面へ進む"
        expect{ click_on "購入を確定する" }.to change{ client.orders.count }.by(1)
      end
      it "パターン2:クレジットカード及び新規配送先住所を選択して注文確認画面へ遷移できること" do
        find("#order_payment_method_credit_card").click
        find("#address________").click
        click_on "確認画面へ進む"
        expect(current_path).to eq confirm_orders_path
      end
      it "パターン2:注文確認画面に新規配送先住所が正しく表示されていること" do
        find("#order_payment_method_credit_card").click
        find("#address________").click
        click_on "確認画面へ進む"
        expect(page).to have_content other_delivery.post_number
        expect(page).to have_content other_delivery.address
        expect(page).to have_content other_delivery.receiver
      end
      it "パターン2:注文確認画面から購入確定できること" do
        find("#order_payment_method_credit_card").click
        find("#address________").click
        click_on "確認画面へ進む"
        expect{ click_on "購入を確定する" }.to change{ client.orders.count }.by(1)
      end
      it "パターン2:注文時に登録した配送先が配送先一覧画面で確認できること" do
        find("#order_payment_method_credit_card").click
        find("#address________").click
        click_on "確認画面へ進む"
        expect{ click_on "購入を確定する" }.to change{ client.deliveries.count }.by(1)
        visit deliveries_path
        within "tbody" do
          expect(page).to have_content other_delivery.post_number
          expect(page).to have_content other_delivery.address
          expect(page).to have_content other_delivery.receiver
        end
      end
      it "購入確定後にサンクスページへ遷移できていること" do
        find("#order_payment_method_bank_transfer").click
        select "#{new_delivery.post_number} #{new_delivery.address} #{new_delivery.receiver}", from: "delivery_id"
        click_on "確認画面へ進む"
        click_on "購入を確定する"
        expect(current_path).to eq thanks_orders_path
      end
    end
    context "マイページから退会" do
      before do
        click_on "マイページ"
        click_on "編集する"
        click_on "退会する"
      end
      it "退会するボタン押下でアラート画面に遷移していること" do
        expect(current_path).to eq client_cancel_clients_path(client,client.id)
      end
      it "退会しないボタン押下でマイページ画面へ遷移していること" do
        click_on "退会しない"
        expect(current_path).to eq client_path(client)
      end
      it "退会するボタン押下でトップ画面へ遷移していること" do
        click_on "退会する"
        expect(current_path).to eq root_path
      end
      it "退会後のヘッダーが未ログイン状態になっていること" do
        click_on "退会する"
        expect(page).to have_no_content "ようこそ、#{client.get_full_name}さん！"
      end
      it "退会したアカウントで再ログインできないこと" do
        click_on "退会する"
        click_on "ログイン"
        fill_in "client[email]",	with: client.email
        fill_in "client[password]",	with: client.password
        click_button "ログイン"
        expect(current_path).to eq new_client_session_path
        expect(page).to have_content "このアカウントは退会されています"
      end
    end
  end

  describe "管理者(会員情報)" do
    let!(:login_admin) { create :admin }
    before do
      click_on "マイページ"
      click_on "編集する"
      click_on "退会する"
      click_on "退会する"

      visit new_admin_session_path
      fill_in "admin[email]",	with: login_admin.email
      fill_in "admin[password]",	with: login_admin.password
      click_button "ログイン"
      click_on "会員一覧"
    end
    context "会員一覧画面" do
      it "退会した会員のステータスが退会済になったいること" do
        within "#client-info-#{client.id}" do
          expect(page).to have_content "退会済み"
        end
      end
    end
    context "会員詳細画面" do
      before {click_on "#{client.first_name} #{client.family_name}"}
      it "会員名称リンク押下で詳細画面へ遷移できること" do
        expect(current_path).to eq admin_client_path(client)
      end
      it "詳細画面に会員情報が正しく表示されていること" do
        within "tbody" do
          expect(page).to have_content client.first_name
          expect(page).to have_content client.family_name
          expect(page).to have_content client.first_name_kana
          expect(page).to have_content client.family_name_kana
          expect(page).to have_content client.post_number
          expect(page).to have_content client.address
          expect(page).to have_content client.tel
          expect(page).to have_content client.email
        end
      end
      it "編集するボタン押下で会員編集画面へ遷移できること" do
        click_on "編集する"
        expect(current_path).to eq edit_admin_client_path(client)
      end
    end
    context "会員編集画面" do
      before do
        click_on "#{client.first_name} #{client.family_name}"
        click_on "編集する"
      end
      it "会員情報が編集できること(住所)" do
        fill_in "client[address]",	with: "テスト住所"
        click_on "変更を保存する"
        expect(page).to have_content "テスト住所"
      end
    end
  end
end