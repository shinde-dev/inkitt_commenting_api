# frozen_string_literal: true

module Comments
  class Update < ActiveInteraction::Base
    object :comment
    string :body

    validates :comment, :body, presence: true

    def execute
      comment.body = body

      errors.merge!(comment.errors) unless comment.save

      comment
    end
  end
end
