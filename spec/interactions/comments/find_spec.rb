# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comments::Find, type: :interactions do
  describe 'Find Comments by Id' do
    context 'with valid Id' do
      it 'finds post' do
        comment = create(:comment)
        searched_comment = described_class.run({ id: comment.id })
        expect(searched_comment.valid?).to eq(true)
        expect(comment).to eq(searched_comment.result)
      end
    end

    context 'with invalid Id' do
      it 'returns error with invalid id type' do
        searched_comment = described_class.run({ id: 'invalid' })
        expect(searched_comment.errors.full_messages.to_sentence).to eq('Id is not a valid integer')
      end

      it 'returns error with invalid id value' do
        searched_comment = described_class.run({ id: 123 })
        expect(searched_comment.errors.full_messages.to_sentence).to eq('Comment does not exist')
      end
    end
  end
end
