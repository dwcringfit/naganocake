# 管理者用ECサイト ApplicationController
class Admin::Base < ApplicationController
  # admin.html.erbを読み込み
  layout 'admin'
  # 管理者ログインチェック
  before_action :authenticate_admin!

end
