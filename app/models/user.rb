class User < ApplicationRecord
  # インスタンス（レコード）保存前にself.email.downcase!を実行
  before_save { self.email.downcase! }

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  validates :phone, presence: true, length: { maximum: 20 }
  validates :admin, presence: true, length: { maximum: 1 }

  #認証機能
  has_secure_password

  # 一対多（user：safeties）
  has_many :safeties, dependent: :destroy

  # 直近のsafety１つを取得
  def latestSafety
      return Safety.where(user_id: self.id).order(updated_at: :desc).first
  end

end
