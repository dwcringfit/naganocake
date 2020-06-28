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
  validates :post_number, presence: true
  validates :address, presence: true
  validates :tel, presence: true

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

  # 検索結果を取得
  def self.search(search_word)
    @clients = Client.where(["family_name LIKE ? OR first_name LIKE ?", "%#{search_word}%", "%#{search_word}%"])
  end

end
