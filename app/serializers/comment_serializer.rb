# frozen_string_literal: true

class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body

  belongs_to :post
  belongs_to :parent
end
