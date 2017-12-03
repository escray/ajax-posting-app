#
class Post < ApplicationRecord
  validates_presence_of :content
  belongs_to :user

  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user

  def find_like(user)
    likes.where(user_id: user.id).first
  end

  def find_favorite(user)
    favorites.where(user_id: user.id).first
  end
end
