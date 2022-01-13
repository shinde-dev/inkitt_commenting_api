# frozen_string_literal: true

class Post < ApplicationRecord
  # validations
  validates :title, :body, presence: true
end
