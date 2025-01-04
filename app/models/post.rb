class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_and_belongs_to_many :tags

  validates :title, presence: true, length: { maximum: 100 }
  validates :content, presence: true

  extend FriendlyId
  friendly_id :title, use: :slugged
end
