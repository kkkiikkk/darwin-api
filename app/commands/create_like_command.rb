# frozen_string_literal: true

class CreateLikeCommand < Command
  def initialize(user, post)
    @user = user
    @post = post
  end

  def perform
    if expecting_like.nil?
      create_like
    else
      delete_like
    end
  end

  private

  def expecting_like
    @expecting_like ||= Like.find_by(user: @user, post: @post)
  end

  def create_like
    like = Like.create(user: @user, post: @post)
  end

  def delete_like
    expecting_like.destroy if expecting_like.present?
  end
end