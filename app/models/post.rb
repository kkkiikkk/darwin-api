class Post < ApplicationRecord
  has_many :likes, dependent: :destroy

  validates :title, :image, presence: true
end
