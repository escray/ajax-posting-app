#
class PostsController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :set_post,
                only: %i[like unlike favorite unfavorite toggle_flag update]
  skip_before_action :verify_authenticity_token,
                     only: %i[destroy toggle_flag update]

  def index
    @posts = Post.order('id DESC').limit(10)

    @posts = @posts.where('id < ?', params[:max_id]) if params[:max_id]

    respond_to do |format|
      format.html
      format.js
    end
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

  def update
    @post.update!(post_params)

    render json: { id: @post.id, message: 'ok' }
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy

    render json: { id: @post.id }
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

  def toggle_flag
    @post.flag_at = if @post.flag_at
                      nil
                    else
                      Time.now
                    end

    @post.save!
    render json: { message: 'ok', flag_at: @post.flag_at, id: @post.id }
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:content, :category_id)
  end
end
