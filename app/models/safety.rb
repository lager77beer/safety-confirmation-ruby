class Safety < ApplicationRecord
  belongs_to :disaster
  belongs_to :user

  validates :myself, presence: true, length: { maximum: 10 }
  validates :contact_information, presence: false, length: { maximum: 180 }

end
