# frozen_string_literal: true

module Comments
  class Find < ActiveInteraction::Base
    integer :id

    def execute
      comment = Comment.find_by(id: id)

      comment || errors.add(:base, 'Comment does not exist')
    end
  end
end
