# frozen_string_literal: true

class Post < ApplicationRecord
  # asscociations
  has_many :comments, dependent: :nullify

  # validations
  validates :title, :body, presence: true
end
