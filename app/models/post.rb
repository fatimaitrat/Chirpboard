class Post < ApplicationRecord
  belongs_to :user

  validates :body, presence: true, length: { maximum: 280 }

  scope :descending, -> { order(created_at: :desc) }
end
