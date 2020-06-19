class Order < ApplicationRecord

  # 今日登録された情報を抽出
  scope :created_today, -> { where( "created_at >= ?", Time.zone.now.beginning_of_day)}

end
