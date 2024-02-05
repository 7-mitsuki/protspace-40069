class Comment < ApplicationRecord
  # アソシエーション
  belongs_to :prototype
  belongs_to :user

  # バリデーション
  validates :content, presence: true
end
