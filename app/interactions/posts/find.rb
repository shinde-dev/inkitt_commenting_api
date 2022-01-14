# frozen_string_literal: true

module Posts
  class Find < ActiveInteraction::Base
    integer :id

    def execute
      post = Post.find_by(id: id)

      post || errors.add(:base, 'Post does not exist')
    end
  end
end
