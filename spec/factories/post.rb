# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    title { 'New Post' }
    body { ' This is a new post' }
  end
end
