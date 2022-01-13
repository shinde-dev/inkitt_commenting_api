# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  describe 'POST /create' do
    let(:new_post) { create(:post) }
    let(:valid_attributes) do
      {
        body: 'my comment'
      }
    end

    context 'with valid attributes' do
      it 'creates a new comment' do
        post api_v1_post_comments_url(new_post.id), params: { comment: valid_attributes }, as: :json

        expect(response).to have_http_status(:created)
      end

      it 'creates a new comment with parent comment' do
        parent_id = create(:comment).id
        valid_post = new_post
        post api_v1_post_comments_url(valid_post.id),
             params: { comment: valid_attributes.merge({ parent_id: parent_id }) }, as: :json

        expect(response).to have_http_status(:created)

        json_response = JSON.parse(response.body)
        expect(json_response['parent']['id']).to eq(parent_id)
        expect(json_response['body']).to eq('my comment')
        expect(json_response['post']['id']).to eq(valid_post.id)
        expect(json_response['post']['body']).to eq(valid_post.body)
        expect(json_response['post']['title']).to eq(valid_post.title)
      end
    end

    context 'with invalid attributes' do
      it 'returns error without body' do
        post api_v1_post_comments_url(new_post.id), params: { comment: { body: nil } }, as: :json
        expect(response).to have_http_status(:bad_request)

        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Body is required')
      end

      it 'returns error with invalid post type' do
        expect do
          post api_v1_post_comments_url('invalid'), params: { comment: valid_attributes }, as: :json
        end
          .to raise_error(ActiveRecord::RecordNotFound, 'Id is not a valid integer')
      end

      it 'returns error with invalid post id' do
        expect do
          post api_v1_post_comments_url(123), params: { comment: valid_attributes }, as: :json
        end
          .to raise_error(ActiveRecord::RecordNotFound, 'Id does not exist')
      end

      it 'returns error with invalid parent id type' do
        post api_v1_post_comments_url(new_post.id),
             params: { comment: valid_attributes.merge({ parent_id: 'invalid' }) },
             as: :json
        expect(response).to have_http_status(:bad_request)

        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Parent is not a valid integer')
      end

      it 'returns error with invalid parent id' do
        expect do
          post api_v1_post_comments_url(new_post.id), params: { comment: valid_attributes.merge({ parent_id: 123 }) },
                                                      as: :json
        end
          .to raise_error(ActiveRecord::InvalidForeignKey)
      end
    end
  end
end
