# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'schema' do
    it { is_expected.to have_db_column(:title).of_type(:string) }
    it { is_expected.to have_db_column(:body).of_type(:text) }
  end

  describe 'valid' do
    it 'is valid with valid attributes' do
      expect(create(:post)).to be_valid
    end
  end

  describe 'invalid' do
    it 'is invalid without title' do
      post = build(:post, title: nil)
      expect(post).not_to be_valid
    end

    it 'is invalid without body' do
      post = build(:post, body: nil)
      expect(post).not_to be_valid
    end
  end
end
