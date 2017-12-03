#
class PostsController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :set_post, only: %i[like unlike favorite unfavorite]

  def index
    @posts = Post.order('id DESC').all
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    if @post.save
    else
      render :new
    end
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy
  end

  def like
    unless @post.find_like(current_user)
      Like.create(user: current_user, post: @post)
    end
  end

  def unlike
    like = @post.find_like(current_user)
    like.destroy
    render :like
  end

  def favorite
    unless @post.find_favorite(current_user)
      Favorite.create(user: current_user, post: @post)
    end
  end

  def unfavorite
    favorite = @post.find_favorite(current_user)
    favorite.destroy
    render :favorite
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:content)
  end
end
