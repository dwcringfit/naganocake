class ApplicationController < ActionController::Base
# <<<<<<< HEAD
  layout :layout_by_resource
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  # devise用 layout判定
  def layout_by_resource
    # deviseのコントローラーの場合
    if devise_controller?
      # 各deviseモデルごとに判定
      case resource_name
      when :admin
        'admin'
      when :client
        'client'
      end
    else
      # deviseではないコントローラーの場合
      'application'
    end
  end

  # ログイン後のパス設定（devise）
  def after_sign_in_path_for(resource)
    case resource
    when Admin
      admin_root_path
    when Client
      root_path
    end
  end

  # 新規登録後のパス設定（devise）
  def after_sign_up_path_for(resource)
    case resource
    when Admin
      # 管理者用の新規登録画面なし
    when Client
      root_path
    end
  end

  # ログアウト後のパス設定（devise）
  def after_sign_out_path_for(resource)
    case resource
    when :admin
      admin_root_path
    when :client
      root_path
    end
  end

  # 会員（新規登録）ストロングパラメータ設定
  def configure_permitted_parameters
    attribute = [
      :first_name,
      :family_name,
      :first_name_kana,
      :family_name_kana,
      :post_number,
      :address,
      :tel
    ]
    devise_parameter_sanitizer.permit(:sign_up, keys: attribute)
  end
# =======
	
# >>>>>>> 00d6e5476c21e950e684f1ecc371eadcdad50420
end
