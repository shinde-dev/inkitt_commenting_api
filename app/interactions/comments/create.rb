# frozen_string_literal: true

module Comments
  class Create < ActiveInteraction::Base
    object :post
    integer :parent_id, default: nil
    string :body

    validates :post, :body, presence: true

    def execute
      comment = post.comments.new(inputs)

      errors.merge!(comment.errors) unless comment.save

      comment
    end
  end
end
