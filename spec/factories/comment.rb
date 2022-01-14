# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    post
    body { 'This is a new comment' }

    trait :with_parent do
      association :parent, factory: :comment
    end
  end
end
