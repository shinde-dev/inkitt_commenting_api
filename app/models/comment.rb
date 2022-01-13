# frozen_string_literal: true

class Comment < ApplicationRecord
  # associations
  belongs_to :post
  belongs_to :parent, class_name: 'Comment', optional: true
  has_many :replies, class_name: 'Comment', foreign_key: :parent_id, dependent: :nullify, inverse_of: false

  # validations
  validates :body, presence: true

  # scopes
  scope :by_created_at, -> { order(created_at: :desc) }
  scope :without_parent, -> { where(parent_id: nil) }
end
