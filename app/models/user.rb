#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :posts

  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post

  has_many :favorites, dependent: :destroy
  has_many :favorited_posts, through: :favorites, source: :post

  def display_name
    email.split('@').first
  end

  def admin?
    role == 'admin'
  end
end
