class Client < ApplicationRecord

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :cart_items, dependent: :destroy
  has_many :items, through: :cart_item, dependent: :destroy
  has_many :deliveries, dependent: :destroy
  has_many :orders, dependent: :destroy


  # バリデーション処理
  validates :first_name, presence: true
  validates :family_name, presence: true
  validates :first_name_kana, presence: true
  validates :family_name_kana, presence: true
  validates :post_number, presence: true, format: {with: /\A[0-9]{3}[0-9]{4}\z/}
  validates :address, presence: true, length: {maximum:250}
  validates :tel, presence: true, format: { with: /\A\d{10}$|^\d{11}\z/ }

  # 退会済み会員の場合はエラー
  def active_for_authentication?
    super && self.is_valid
  end

  # 退会済みエラーメッセージ
  def inactive_message
    self.is_valid ? super : :deleted_account
  end

  # フルネームを取得
  def get_full_name
    self.first_name + self.family_name
  end

  # フルネームを取得(カナ)
  def get_full_name_kana
    self.first_name_kana + self.family_name_kana
  end
end
