# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comments::FindWithReplies, type: :interactions do
  describe 'List replies of a Comment order by created at desc' do
    context 'with valid comment' do
      it 'lists replies' do
        parent_comment = create(:comment)
        first_reply = create(:comment, post: parent_comment.post, parent: parent_comment)
        second_reply = create(:comment, post: parent_comment.post, parent: parent_comment)
        replies = described_class.run({ comment: parent_comment }).result

        expect(replies.count).to eq(2)
        # Last created comment appears first by ordering
        expect(replies[0].id).to eq(second_reply.id)
        expect(replies[1].id).to eq(first_reply.id)
      end

      it 'lists replies with pagination' do
        # create 3 replies with per page limit 2
        parent_comment = create(:comment)
        create(:comment, post: parent_comment.post, parent: parent_comment)
        create(:comment, post: parent_comment.post, parent: parent_comment)
        create(:comment, post: parent_comment.post, parent: parent_comment)
        expect(Comment.count).to eq(4)

        # Page 1 will return 2 records
        replies = described_class.run({ comment: parent_comment }).result
        expect(replies.count).to eq(2)

        # Page 2 will return 1 record only as we created only 3 replies
        replies = described_class.run({ comment: parent_comment, page: 2 }).result
        expect(replies.count).to eq(1)
      end

      it 'does not returns error if no replies exist' do
        replies = described_class.run({ comment: create(:comment) }).result

        expect(replies.count).to eq(0)
        expect(replies).to eq([])
      end
    end

    context 'with invalid comment' do
      it 'returns error without comment' do
        replies = described_class.run({})
        expect(replies.errors.full_messages.to_sentence).to eq('Comment is required')
      end

      it 'returns error with nil comment' do
        replies = described_class.run({ post: nil })
        expect(replies.errors.full_messages.to_sentence).to eq('Comment is required')
      end
    end
  end
end
