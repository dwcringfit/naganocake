Rails.application.routes.draw do

  namespace :admin do
    get 'clients/index'
    get 'clients/show'
    get 'clients/edit'
    get 'clients/update'
  end
  # 顧客用ルーティング
  scope module: :client do

    # 会員画面トップ
    root to: 'top#top'

    # 会員ユーザー
    devise_for :clients, controllers: {
      sessions: 'client/clients/sessions',
      registrations: 'client/clients/registrations',
      passwords: 'client/clients/passwords'
    }
    resources :clients, only: [:show, :edit, :update] do
      # 退会処理
      collection do
        get :cancel, to: 'clients#confirm_cancel'
        post :cancel, to: 'clients#cancel'
      end
    end

    # 商品
    resources :items, only: [:index, :show]

    # カート
    resources :cart_items, only: [:index, :create, :update, :destroy], param: :item_id
    delete :cart_items, to: 'cart_items#destroy_all'

    # 注文
    resources :orders, only: [:new, :index, :create, :show] do
      collection do
        post :confirm, to: 'orders#confirm'
        get :thanks, to: 'orders#thanks'
      end
    end

    # 配送先
    resources :deliveries, except: [:show]
  end

  # 管理者ユーザー
  devise_for :admins, only: [:sign_in, :sign_out, :session]

  # 管理者用ルーティング
  namespace :admin do

    # 管理画面トップ
    root to: 'top#top'

    # 顧客管理
    resources :clients, except: [:create, :destroy]

    # 商品管理
    resources :items, except: [:destroy]

    # 注文履歴
    resources :orders, except: [:create, :edit, :destroy] do
      # 注文商品
      resources :order_items, only: :update
    end

    # 商品ジャンル
    resources :genres, except: [:show, :destroy]
  end
end
