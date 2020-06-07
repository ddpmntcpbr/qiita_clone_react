class Api::V1::Current::ArticleSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :status, :created_at, :updated_at, :likes_count
  belongs_to :user

  def likes_count
    object.article_likes.count
  end
end
