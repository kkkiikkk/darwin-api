module Admin
  class PostsController < ApplicationController
    def create
      @post = Post.new(title: params[:title], image: params[:image], blocks: params[:blocks])

      if @post.save
        render json: { data: @post }, status: :created
      else
        render json: { msg: 'Unprocessable Post', errors: @post.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end
end