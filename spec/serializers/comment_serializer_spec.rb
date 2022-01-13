# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentSerializer, type: :serializers do
  describe 'CommentSerializer' do
    context 'with valid object' do
      it 'returns valid attributes' do
        comment = create(:comment, :with_parent)
        serializer = described_class.new(comment)
        object_hash = serializer.serializable_hash

        expect(object_hash[:id]).to eq(comment.id)
        expect(object_hash[:body]).to eq(comment.body)
        expect(object_hash[:parent][:id]).to eq(comment.parent_id)

        expect(object_hash[:post][:id]).to eq(comment.post.id)
        expect(object_hash[:post][:body]).to eq(comment.post.body)
        expect(object_hash[:post][:title]).to eq(comment.post.title)
      end
    end
  end
end
