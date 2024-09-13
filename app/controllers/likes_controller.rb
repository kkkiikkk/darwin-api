class LikesController < ApplicationController
  before_action :authenticate_user!, :set_post, only: [:create]

  def create
    create_like_command = CreateLikeCommand.new(current_user, @post)

    if create_like_command.perform
      puts  "created"
      render json: { data: {}  }, status: :created
    else
      render json: { error: 'Error creating like' }, status: :unprocessable_entity
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
