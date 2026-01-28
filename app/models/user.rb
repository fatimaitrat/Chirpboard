class User < ApplicationRecord

  has_secure_password

  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [100,100]
    attachable.variant :medium, resize_to_limit: [300,300]
  end

  has_many :posts, dependent: :destroy

  #People I follow
  has_many :active_follows, class_name: 'Follow', foreign_key: 'follower_id', dependent: :destroy
  has_many :following, through: :active_follows,source: :followed

  #People following me 
  has_many :passive_follows, class_name: 'Follow', foreign_key: 'followed_id', dependent: :destroy
  has_many :followers, through: :passive_follows, source: :follower

  validates :username, presence: true, uniqueness: true
  
  validates :email, presence: true, uniqueness: true

  validates :password, presence: true, allow_nil: true
  def following?(other_user)
    following.include?(other_user)
  end

  def follow(other_user)
    return if following.include?(other_user)

    return if self == other_user

    following << other_user
  end
  def unfollow(other_user)
    following.delete(other_user)
  end
end

