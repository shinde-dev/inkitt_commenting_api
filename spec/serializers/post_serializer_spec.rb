# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostSerializer, type: :serializers do
  describe 'PostSerializer' do
    context 'with valid object' do
      it 'returns valid attributes' do
        post = create(:post)
        serializer = described_class.new(post)
        object_hash = serializer.serializable_hash

        expect(object_hash[:id]).to eq(post.id)
        expect(object_hash[:body]).to eq(post.body)
        expect(object_hash[:title]).to eq(post.title)
      end
    end
  end
end
