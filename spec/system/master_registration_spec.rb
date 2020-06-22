require 'rails_helper'

RSpec.describe "マスタ登録（管理者）", type: :system do

  let!(:login_admin) { create :admin }

  before do |login|
    unless login.metadata[:skip_login]
      visit new_admin_session_path
      fill_in "admin[email]",	with: login_admin.email
      fill_in "admin[password]",	with: login_admin.password
      click_button "ログイン"
    end
  end

  describe "ログイン画面" do
    context "登録済み管理者でログイン" do
      it "ログイン後に管理者トップ画面へ遷移" do expect(current_path).to eq admin_root_path end
      it "ログイン完了メッセージが表示" do expect(page).to have_content "ログインしました" end
    end
    context "未登録管理者でログイン", :skip_login do
      before do
        visit new_admin_session_path
        fill_in "admin[email]",	with: "notAdmin@test.com"
        fill_in "admin[password]",	with: "password"
        click_button "ログイン"
      end
      it "非ログイン状態でその他管理画面へ遷移できないこと" do
        visit admin_items_path
        expect(current_path).to eq new_admin_session_path
      end
      it "ログイン失敗後に再度ログイン画面へ遷移" do expect(current_path).to eq new_admin_session_path end
      it "ログイン失敗のエラーメッセージを表示" do expect(page).to have_content "メールアドレスまたはパスワードが違います" end
    end
    context "ログアウト" do
      before { click_on "ログアウト" }
      it "ログアウト後にログイン画面へ遷移" do expect(current_path).to eq new_admin_session_path end
      it "ログアウト完了メッセージが表示" do expect(page).to have_content "ログアウトしました" end
    end
  end

  describe "管理者トップ画面" do
    context "画面表示内容" do
      it "本日の注文件数が表示されていること" do expect(page).to have_content "本日の注文件数：#{Order.created_today.count}件" end
    end
    context "ヘッダーからの画面遷移" do
      it "ジャンル一覧へ遷移できること" do
        click_on "ジャンル一覧"
        expect(current_path).to eq admin_genres_path
      end
      it "商品一覧へ遷移できること" do
        click_on "商品一覧"
        expect(current_path).to eq admin_items_path
      end
      it "会員一覧へ遷移できること" do
        click_on "会員一覧"
        expect(current_path).to eq admin_clients_path
      end
      it "注文履歴一覧へ遷移できること" do
        click_on "注文履歴一覧"
        expect(current_path).to eq admin_orders_path
      end
    end
  end

  describe "ジャンル画面" do
    before { visit admin_genres_path }
    context "ジャンル新規登録" do
      before do
        fill_in "genre[name]", with: "シュークリーム"
        click_button "追加"
      end
      it "新規登録後にジャンル一覧画面へ再描画されていること" do expect(current_path).to eq admin_genres_path end
      it "新規登録したジャンルが一覧表示されていること" do expect(page).to have_content "シュークリーム" end
    end
  end

  describe "商品画面" do
    let(:genre) { create :genre }
    before { visit admin_items_path }

    context "商品新規登録画面の表示" do
      before { click_on "新規登録" }
      it "一覧画面から新規登録の押下で登録画面に遷移できること" do expect(current_path).to eq new_admin_item_path end
      it "画面に商品新規登録の名称が表示されていること" do expect(page).to have_content "商品新規登録" end
    end

    context "新規商品の登録" do
      let!(:new_item) { build :item, name: "栗のケーキ", context: "季節の栗を使用した、お店自慢のケーキです。", genre: genre }
      before do
        click_on "新規登録"
        fill_in "item[name]",	with: new_item.name
        fill_in "item[context]", with: new_item.context
        select new_item.genre.name, from: "ジャンル"
        fill_in "item[price]", with: new_item.price
        select new_item.sale_status_name, from: "販売ステータス"
        click_button "新規登録"
        @item_new = Item.find_by(name: new_item.name)
      end
      it "新規登録後に商品詳細画面へ遷移すること" do
        expect(current_path).to eq admin_item_path(@item_new)
      end
      it "登録した商品内容が詳細画面に表示されていること" do
        expect(page).to have_content @item_new.name
        expect(page).to have_content @item_new.context
        expect(page).to have_content @item_new.price_tax_included
        expect(page).to have_content @item_new.price
        expect(page).to have_content @item_new.sale_status_name
      end
      it "商品詳細画面から商品一覧へ遷移できること" do
        click_on "商品一覧"
        expect(current_path).to eq admin_items_path
      end
      it "登録した商品内容が一覧画面に表示されていること" do
        click_on "商品一覧"
        within "table" do
          expect(page.find('tbody')).to have_content @item_new.name
          expect(page.find('tbody')).to have_content @item_new.price
          expect(page.find('tbody')).to have_content @item_new.genre.name
          expect(page.find('tbody')).to have_content @item_new.sale_status_name
        end
      end
    end

    context "商品編集画面の表示" do
      let!(:item) { create :item, genre: genre}
      before do
        visit current_path
        click_on item.name
      end
      it "商品一覧から商品詳細画面へ遷移できること" do expect(current_path).to eq admin_item_path(item) end
      it "一覧より選択した商品が詳細画面に表示されていること" do
        expect(page).to have_content item.name
        expect(page).to have_content item.context
        expect(page).to have_content item.price_tax_included
        expect(page).to have_content item.price
        expect(page).to have_content item.sale_status_name
      end
      it "商品詳細画面から商品編集画面へ遷移できること" do
        click_on "編集する"
        expect(current_path).to eq edit_admin_item_path(item)
      end
      it "商品内容が編集画面のフィールドに正しく入力されていること" do
        click_on "編集する"
        have_field "item[name]", with: item.name
        have_field "item[context]", with: item.context
        have_field "item[price]", with: item.price
        have_select "item[genre_id]", selected: item.genre.name
        have_select "item[is_sale]", selected: item.sale_status_name
      end
    end

    context "既存商品の編集" do
      let!(:item) { create :item, genre: genre}
      let!(:other_genre) { create :genre, name: "プリン"}
      let!(:edit_item) { build :item, name: "苺のプリン", context: "季節の苺を使用した、お店自慢のプリンです。", price: 500, is_sale: false, genre: other_genre }
      before do
        visit edit_admin_item_path(item)
        fill_in "item[name]",	with: edit_item.name
        fill_in "item[context]", with: edit_item.context
        select edit_item.genre.name, from: "ジャンル"
        fill_in "item[price]", with: edit_item.price
        select edit_item.sale_status_name, from: "販売ステータス"
        click_on "変更を保存"
        @item_edit = Item.find_by(name: edit_item.name)
      end
      it "編集後に商品詳細画面へ遷移すること" do
        expect(current_path).to eq admin_item_path(@item_edit)
      end
      it "編集した商品内容が詳細画面に表示されていること" do
        expect(page).to have_content @item_edit.name
        expect(page).to have_content @item_edit.context
        expect(page).to have_content @item_edit.price_tax_included
        expect(page).to have_content @item_edit.price
        expect(page).to have_content @item_edit.sale_status_name
      end
      it "商品詳細画面から商品一覧へ遷移できること" do
        click_on "商品一覧"
        expect(current_path).to eq admin_items_path
      end
      it "編集した商品内容が一覧画面に表示されていること" do
        click_on "商品一覧"
        within "table" do
          expect(page.find('tbody')).to have_content @item_edit.name
          expect(page.find('tbody')).to have_content @item_edit.price
          expect(page.find('tbody')).to have_content @item_edit.genre.name
          expect(page.find('tbody')).to have_content @item_edit.sale_status_name
        end
      end
    end
  end
end
