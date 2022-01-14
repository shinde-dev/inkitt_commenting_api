# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'schema' do
    it { is_expected.to have_db_column(:parent_id).of_type(:integer) }
    it { is_expected.to have_db_column(:post_id).of_type(:integer) }
    it { is_expected.to have_db_column(:body).of_type(:text) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:post) }
    it { is_expected.to belong_to(:parent).optional }
    it { is_expected.to have_many(:replies) }
  end

  describe 'valid' do
    it 'is valid with valid attributes' do
      expect(create(:comment)).to be_valid
    end

    it 'is valid with parent' do
      comment = create(:comment, :with_parent)
      expect(comment).to be_valid
      expect(comment.parent).to be_a(described_class)
    end

    it 'is valid without parent' do
      comment = build(:comment, parent_id: nil)
      expect(comment).to be_valid
    end

    it 'is valid with replies' do
      comment = create(:comment, :with_parent)
      expect(comment.parent).to be_a(described_class)
      expect(comment.parent.replies.first).to eq(comment)
    end

    it 'has multiple replies' do
      comment1 = create(:comment)
      comment2 = create(:comment, parent: comment1)
      comment3 = create(:comment, parent: comment1)

      expect(comment1.replies[0]).to eq(comment2)
      expect(comment1.replies[1]).to eq(comment3)
      expect(comment2.parent.replies[0]).to eq(comment2)
      expect(comment3.parent.replies[1]).to eq(comment3)
    end

    context 'with order by' do
      it 'returns comments in order by created at' do
        first_comment = create(:comment)
        last_comment = create(:comment, post: first_comment.post)

        comments = described_class.by_created_at
        expect(comments.count).to eq(2)
        # Last created comment appears first by ordering
        expect(comments[0].id).to eq(last_comment.id)
        expect(comments[1].id).to eq(first_comment.id)
      end
    end
  end

  describe 'invalid' do
    it 'is invalid without post' do
      comment = build(:comment, post_id: nil)
      expect(comment).not_to be_valid
    end

    it 'is invalid with invalid parent' do
      expect { create(:comment, parent_id: 'invalid') }.to raise_error(ActiveRecord::InvalidForeignKey)
    end
  end
end
