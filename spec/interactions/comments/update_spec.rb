# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comments::Update, type: :interactions do
  describe 'Update Comments' do
    let(:new_comment) { create(:comment) }
    let(:attributes) do
      {
        body: 'My new Comment updated'
      }
    end

    context 'with valid attributes' do
      it 'updates valid comment' do
        comment = new_comment
        updated_comment = described_class.run(attributes.merge({ comment: comment }))
        expect(updated_comment.valid?).to eq(true)
        expect(updated_comment.body).to eq('My new Comment updated')
      end
    end

    context 'with invalid attributes' do
      it 'returns error without body' do
        comment = described_class.run({}.merge({ comment: new_comment }))
        expect(comment.errors.full_messages.to_sentence).to eq('Body is required')
      end

      it 'returns error with empty body' do
        comment = described_class.run({ body: nil }.merge({ comment: new_comment }))
        expect(comment.errors.full_messages.to_sentence).to eq('Body is required')
      end

      it 'returns error without comment object' do
        comment = described_class.run(attributes)
        expect(comment.errors.full_messages.to_sentence).to eq('Comment is required')
      end
    end
  end
end
