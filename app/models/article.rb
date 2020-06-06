class Article < ApplicationRecord
  belongs_to :user
  has_many :comment, dependent: :destroy
  has_many :article_likes, dependent: :destroy

  validates :title, presence: true, length: { maximum: 50 }
  validates :content, presence: true
end
