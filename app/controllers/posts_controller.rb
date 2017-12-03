#
class PostsController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]

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
    @post = Post.find(params[:id])
    unless @post.find_like(current_user)
      Like.create(user: current_user, post: @post)
    end
  end

  def unlike
    @post = Post.find(params[:id])
    like = @post.find_like(current_user)
    like.destroy
    render :like
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end
end
