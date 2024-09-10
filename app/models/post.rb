class Post < ApplicationRecord
  validates :title, :image, presence: true
end
