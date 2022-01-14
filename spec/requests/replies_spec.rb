# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Replies', type: :request do
  describe 'GET /index' do
    context 'with valid comment' do
      it 'lists replies' do
        parent_comment = create(:comment)
        first_reply = create(:comment, post: parent_comment.post, parent: parent_comment)
        second_reply = create(:comment, post: parent_comment.post, parent: parent_comment)

        get api_v1_post_comment_replies_url(parent_comment.post.id, parent_comment.id), params: { page: 1 }
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)

        expect(json_response.count).to eq(2)
        # Last created comment appears first by ordering
        expect(json_response[0]['id']).to eq(second_reply.id)
        expect(json_response[1]['id']).to eq(first_reply.id)
      end

      it 'lists replies with pagination' do
        # create 3 replies with per page limit 2
        parent_comment = create(:comment)
        create(:comment, post: parent_comment.post, parent: parent_comment)
        create(:comment, post: parent_comment.post, parent: parent_comment)
        create(:comment, post: parent_comment.post, parent: parent_comment)
        expect(Comment.count).to eq(4)

        # Page 1 will return 2 records
        get api_v1_post_comment_replies_url(parent_comment.post.id, parent_comment.id), params: { page: 1 }
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response.count).to eq(2)

        # Page 2 will return 1 record only as we created only 3 replies
        get api_v1_post_comment_replies_url(parent_comment.post.id, parent_comment.id), params: { page: 2 }
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response.count).to eq(1)
      end

      it 'does not returns error if no replies exist' do
        parent_comment = create(:comment)
        get api_v1_post_comment_replies_url(parent_comment.post.id, parent_comment.id)

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response.count).to eq(0)
        expect(json_response).to eq([])
      end
    end

    context 'with invalid post' do
      it 'returns error with invalid post id' do
        expect do
          get api_v1_post_comment_replies_url(123, create(:comment).id)
        end
          .to raise_error(ActiveRecord::RecordNotFound, 'Post does not exist')
      end

      it 'returns error with nil post' do
        expect do
          get api_v1_post_comment_replies_url(nil)
        end
          .to raise_error(ActionController::UrlGenerationError)
      end
    end

    context 'with invalid comment' do
      it 'returns error with invalid comment id' do
        expect do
          get api_v1_post_comment_replies_url(create(:post).id, 123)
        end
          .to raise_error(ActiveRecord::RecordNotFound, 'Comment does not exist')
      end

      it 'returns error with nil comment' do
        expect do
          get api_v1_post_comment_replies_url(create(:post).id, nil)
        end
          .to raise_error(ActionController::UrlGenerationError)
      end
    end
  end
end
