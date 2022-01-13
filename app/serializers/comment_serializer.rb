# frozen_string_literal: true

class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body

  belongs_to :post
  belongs_to :parent
  has_many :replies

  def replies
    object.replies.by_created_at.limit(ENV.fetch("REPLIES_LIMIT"))
  end
end
