require 'rails_helper'

RSpec.describe "制作から発送", type: :system do
  let!(:client) { create :client }
  let!(:genre) { create :genre }
  let!(:item) { create :item, genre: genre }
  let!(:genre2) { create :genre2 }
  let!(:item2) { create :item2, genre: genre2 }
  let!(:order) { create :order, client: client }

  describe "制作から発送まで(管理者)" do
    let!(:login_admin) { create :admin }
    before do
      create(:order_item, order: order, item: item )
      create(:order_item2, order: order, item: item2 )
      visit admin_root_path
      click_link "ログイン"
      fill_in "admin[email]",	with: login_admin.email
      fill_in "admin[password]",	with: login_admin.password
      click_button "ログイン"
    end
    context "管理者の注文情報確認画面の表示" do
      it "メールアドレス・パスワードを入力しログインできること" do
        expect(current_path).to eq admin_root_path
        expect(page).to have_content "ログインしました"
      end
      it "ヘッダから注文履歴一覧へ画面遷移できること" do
        click_on "注文履歴一覧"
        expect(current_path).to eq admin_orders_path
      end
      it "注文履歴一覧から注文履歴詳細画面へ遷移できること" do
        click_on "注文履歴一覧"
        click_link "#{order.created_at.strftime('%Y/%m/%d %H:%M:%S')}"
        expect(current_path).to eq admin_order_path(order)
      end
    end
    context "注文情報の確認とステータス変更" do
      before do
        click_on "注文履歴一覧"
        click_link "#{order.created_at.strftime('%Y/%m/%d %H:%M:%S')}"
      end
      it "注文ステータスを入金確認に更新した場合(更新後 注文:入金確認、製作:製作待ち)" do
        select "入金確認", from: "status"
        find('#order-status').click
        expect(page).to have_select( "status", selected: "入金確認")
        order.order_items.each do |orderItem|
          expect(page).to have_select( "order_item[production_status]", selected: "製作待ち")
        end
      end
      it "制作ステータスを製作中に更新した場合(更新後 注文:製作中)" do
        select "入金確認", from: "status"
        find('#order-status').click
        @order_item = order.order_items.first
        select "製作中", from: "order_item[production_status]", match: :first
        find_by_id("orderItem-status-#{@order_item.id}").click
        expect(page).to have_select( "status", selected: "製作中")
      end
      it "制作ステータスをすべて製作完了に更新した場合(更新後 注文:発送準備中)" do
        select "入金確認", from: "status"
        find('#order-status').click
        select "製作中", from: "order_item[production_status]", match: :first
        find_by_id("orderItem-status-#{order.order_items.first.id}").click
        order.order_items.each do |orderItem|
          within "#order-item-field-#{orderItem.id}" do
            select "製作完了", from: "order_item[production_status]"
            find_by_id("orderItem-status-#{orderItem.id}").click
            expect(page).to have_select( "order_item[production_status]", selected: "製作完了")
          end
        end
        expect(page).to have_select( "status", selected: "発送準備中")
      end
      it "注文ステータスを発送済みに更新した場合(更新後 注文:発送済み)" do
        select "入金確認", from: "status"
        find('#order-status').click
        select "製作中", from: "order_item[production_status]", match: :first
        find_by_id("orderItem-status-#{order.order_items.first.id}").click
        order.order_items.each do |orderItem|
          within "#order-item-field-#{orderItem.id}" do
            select "製作完了", from: "order_item[production_status]"
            find_by_id("orderItem-status-#{orderItem.id}").click
            expect(page).to have_select( "order_item[production_status]", selected: "製作完了")
          end
        end
        select "発送済み", from: "status"
        find('#order-status').click
        expect(page).to have_select( "status", selected: "発送済み")
      end
    end
    context "管理者アカウントのログアウト" do
      it "ログアウト後に管理者ログイン画面へ遷移していること" do
        click_on "ログアウト"
        expect(current_path).to eq new_admin_session_path
      end
    end
  end

  describe "ECサイト(会員)）" do
    before do
      order.update(status: 4)
      create(:order_item, production_status: 3, order: order, item: item )
      create(:order_item2, production_status: 3, order: order, item: item2 )
      visit new_client_session_path
      fill_in "client[email]",	with: client.email
      fill_in "client[password]",	with: client.password
      click_button "ログイン"
    end
    context "会員ログイン" do
      it "ログイン後にトップ画面へ遷移していること" do expect(current_path).to eq root_path end
      it "ログイン後にヘッダー表示が変わっていること" do
        expect(page).to have_content "ようこそ、#{client.get_full_name}さん！"
      end
      it "ヘッダーからマイページへ遷移できること" do
        click_on "マイページ"
        expect(current_path).to eq client_path(client)
      end
    end
    context "会員マイページ" do
      before do
        click_on "マイページ"
      end
      it "マイページの会員情報が正しく表示されていること" do
        expect(page).to have_content "#{client.first_name} #{client.family_name}"
        expect(page).to have_content "#{client.first_name_kana} #{client.family_name_kana}"
        expect(page).to have_content client.post_number
        expect(page).to have_content client.address
        expect(page).to have_content client.tel
        expect(page).to have_content client.email
      end
      it "注文履歴一覧画面へ遷移できること" do
        first("a[href='#{orders_path}']").click
        expect(current_path).to eq orders_path
      end
    end
    context "注文履歴一覧画面" do
      before do
        click_on "マイページ"
        first("a[href='#{orders_path}']").click
      end
      it "注文履歴一覧画面の内容が正しく表示されていること" do
        @orders = client.orders
        within "tbody" do
          @orders.each do |order|
            expect(page).to have_content order.created_at.strftime('%Y/%m/%d')
            expect(page).to have_content order.post_number
            expect(page).to have_content order.address
            expect(page).to have_content order.receiver
            order.items.each{|item| expect(page).to have_content item.name }
            expect(page).to have_content order.total_fee
            expect(page).to have_content order.status_i18n
          end
        end
      end
    end
    context "注文履歴詳細画面" do
      before do
        click_on "マイページ"
        first("a[href='#{orders_path}']").click
        first("a[href='#{order_path(order)}']").click
      end
      it "注文情報が正しく表示されていること" do
        expect(page).to have_content order.created_at.strftime('%Y/%m/%d')
        expect(page).to have_content order.post_number
        expect(page).to have_content order.address
        expect(page).to have_content order.receiver
        expect(page).to have_content order.payment_method_i18n
        expect(page).to have_content order.status_i18n
      end
      it "請求情報が正しく表示されていること" do
        expect(page).to have_content (order.total_fee - order.postage)
        expect(page).to have_content order.postage
        expect(page).to have_content order.total_fee
      end
      it "注文内容が正しく表示されていること" do
        order.order_items.each do |order_item|
          expect(page).to have_content order_item.item.name
          expect(page).to have_content order_item.price
          expect(page).to have_content order_item.item_count
          expect(page).to have_content order_item.subtotal
        end
      end
    end
  end
end