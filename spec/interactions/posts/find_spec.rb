# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Posts::Find, type: :interactions do
  describe 'Find Posts by Id' do
    context 'with valid Id' do
      it 'finds post' do
        post = create(:post)
        searched_post = described_class.run({ id: post.id })
        expect(searched_post.valid?).to eq(true)
        expect(searched_post.result).to eq(post)
      end
    end

    context 'with invalid Id' do
      it 'returns error with invalid id type' do
        searched_post = described_class.run({ id: 'invalid' })
        expect(searched_post.errors.full_messages.to_sentence).to eq('Id is not a valid integer')
      end

      it 'returns error with invalid id value' do
        searched_post = described_class.run({ id: 123 })
        expect(searched_post.errors.full_messages.to_sentence).to eq('Post does not exist')
      end
    end
  end
end
