# frozen_string_literal: true

module Comments
  class List < ActiveInteraction::Base
    object :post
    integer :page, default: 1

    validates :post, presence: true

    def execute
      post.comments.without_parent.by_created_at.page(page)
    end
  end
end
