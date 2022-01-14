# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comments::Create, type: :interactions do
  describe 'Create Comments' do
    let(:new_post) { create(:post) }
    let(:attributes) do
      {
        body: 'My new Comment',
        post: new_post
      }
    end

    context 'with valid attributes' do
      it 'creates valid comment' do
        comment = described_class.run(attributes)
        expect(comment.valid?).to eq(true)
        expect(comment.body).to eq('My new Comment')
      end

      it 'creates valid comment with parent' do
        parent_comment = create(:comment)
        comment = described_class.run(attributes.merge({ parent_id: parent_comment.id }))
        expect(comment.valid?).to eq(true)
        expect(comment.body).to eq('My new Comment')
        expect(comment.result.parent.id).to eq(parent_comment.id)
      end
    end

    context 'with invalid attributes' do
      it 'returns error without body and post' do
        comment = described_class.run({})
        expect(comment.errors.full_messages.to_sentence).to eq('Post is required and Body is required')
      end

      it 'returns error without post' do
        comment = described_class.run({ body: 'my comment' })
        expect(comment.errors.full_messages.to_sentence).to eq('Post is required')
      end

      it 'returns error without body' do
        comment = described_class.run({ post: new_post })
        expect(comment.errors.full_messages.to_sentence).to eq('Body is required')
      end

      it 'returns error with empty body' do
        comment = described_class.run({ body: nil, post: new_post })
        expect(comment.errors.full_messages.to_sentence).to eq('Body is required')
      end
    end
  end
end
