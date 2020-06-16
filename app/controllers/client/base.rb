# 顧客用ECサイト ApplicationController
class Client::Base < ApplicationController
  # client.html.erbを読み込み
  layout 'client'
  # 会員ログインチェック
  before_action :authenticate_client!, except: :top

end
