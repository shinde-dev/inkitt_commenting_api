# frozen_string_literal: true

module Comments
  class FindWithReplies < ActiveInteraction::Base
    object :comment
    integer :page, default: 1

    validates :comment, presence: true

    def execute
      comment.replies.by_created_at.page(page)
    end
  end
end
