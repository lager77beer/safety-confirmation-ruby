class Disaster < ApplicationRecord

  validates :name, presence: true, length: { maximum: 20 }
  
  # 一対多（disaster：safeties）
  has_many :safeties, dependent: :destroy

end
