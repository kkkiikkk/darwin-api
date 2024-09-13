class PostsController < ApplicationController

  def create
    @post = Post.new(title: params[:title], image: params[:image], blocks: params[:blocks])

    if @post.save
      render json: { data: @post }, status: :created
    else
      render json: { msg: "Unprocessable Post", errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    @posts = Post.left_joins(:likes)
    .select('posts.*, COUNT(likes.id) AS likes_count')
    .group('posts.id')

    render json: { data: @posts }, status: :ok
  end

  def show
    @post = Post.find(params[:id]).include(:likes)

    render json: { data: @post }, status: :ok
  rescue ActiveRecord::RecordNotFound
    raise ApiException::NotFound.new('Post not found')
  end
end
