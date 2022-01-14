# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comments::List, type: :interactions do
  describe 'List Comments by Post order by created at desc' do
    context 'with valid post' do
      it 'lists comments' do
        first_comment = create(:comment)
        last_comment = create(:comment, post: first_comment.post)
        comments = described_class.run({ post: first_comment.post }).result

        expect(comments.count).to eq(2)
        # Last created comment appears first by ordering
        expect(comments[0].id).to eq(last_comment.id)
        expect(comments[1].id).to eq(first_comment.id)
      end

      it 'lists comments with pagination' do
        # create 3 comments with per page limit 2
        first_comment = create(:comment)
        create(:comment, post: first_comment.post)
        create(:comment, post: first_comment.post)
        expect(Comment.count).to eq(3)

        # Page 1 will return 2 records
        comments = described_class.run({ post: first_comment.post, page: 1 }).result
        expect(comments.count).to eq(2)

        # Page 2 will return 1 record only as we created only 3 records
        comments = described_class.run({ post: first_comment.post, page: 2 }).result
        expect(comments.count).to eq(1)
      end

      it 'does not returns error if no comments exist' do
        comments = described_class.run({ post: create(:post) }).result

        expect(comments.count).to eq(0)
        expect(comments).to eq([])
      end
    end

    context 'with invalid post' do
      it 'returns error without post' do
        comments = described_class.run({})
        expect(comments.errors.full_messages.to_sentence).to eq('Post is required')
      end

      it 'returns error with nil post' do
        comments = described_class.run({ post: nil })
        expect(comments.errors.full_messages.to_sentence).to eq('Post is required')
      end
    end
  end
end
