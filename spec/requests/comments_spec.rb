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
          .to raise_error(ActiveRecord::RecordNotFound, 'Post does not exist')
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

  describe 'PUT /update' do
    let(:comment) { create(:comment) }
    let(:valid_attributes) do
      {
        body: 'updated comment'
      }
    end

    context 'with valid attributes' do
      it 'updates a comment' do
        put api_v1_post_comment_url(comment.post.id, comment.id), params: { comment: valid_attributes }, as: :json

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['body']).to eq('updated comment')
      end
    end

    context 'with invalid attributes' do
      it 'returns error with invalid comment id' do
        expect do
          put api_v1_post_comment_url(comment.post.id, 123), params: { comment: { body: nil } }, as: :json
        end
          .to raise_error(ActiveRecord::RecordNotFound, 'Comment does not exist')
      end

      it 'returns error with invalid post id' do
        expect do
          put api_v1_post_comment_url(123, comment.id), params: { comment: { body: nil } }, as: :json
        end
          .to raise_error(ActiveRecord::RecordNotFound, 'Post does not exist')
      end

      it 'returns error with empty body' do
        put api_v1_post_comment_url(comment.post.id, comment.id), params: { comment: { body: nil } }, as: :json

        expect(response).to have_http_status(:bad_request)
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Body is required')
      end

      it 'does not update parent id' do
        comment = create(:comment, :with_parent)
        expect(comment.parent.id).not_to be nil
        put api_v1_post_comment_url(comment.post.id, comment.id),
            params: { comment: valid_attributes.merge({ parent_id: 123 }) }, as: :json
        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        expect(json_response['parent']['id']).to eq(comment.parent.id)
      end
    end
  end

  describe 'GET /index' do
    context 'with valid post' do
      it 'lists comments' do
        first_comment = create(:comment)
        last_comment = create(:comment, post: first_comment.post)

        get api_v1_post_comments_url(first_comment.post.id), params: { page: 1 }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)

        expect(json_response.count).to eq(2)
        # Last created comment appears first by ordering
        expect(json_response[0]['id']).to eq(last_comment.id)
        expect(json_response[1]['id']).to eq(first_comment.id)
      end

      it 'lists comments with replies' do
        first_comment = create(:comment)
        second_comment = create(:comment, post: first_comment.post, parent: first_comment)
        get api_v1_post_comments_url(first_comment.post.id), params: { page: 1 }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response.count).to eq(1)
        expect(json_response[0]['id']).to eq(first_comment.id)
        expect(json_response[0]['replies'].count).to eq(1)
        expect(json_response[0]['replies'][0]['id']).to eq(second_comment.id)
      end

      it 'lists top level comments i.e. without parents' do
        first_comment = create(:comment)
        create(:comment, post: first_comment.post, parent: first_comment)
        get api_v1_post_comments_url(first_comment.post.id), params: { page: 1 }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        # Returns only one i.e. first comment which do not have a parent
        expect(json_response.count).to eq(1)
        expect(json_response[0]['id']).to eq(first_comment.id)
      end

      it 'lists comments with pagination' do
        # create 3 comments with per page limit 2
        first_comment = create(:comment)
        create(:comment, post: first_comment.post)
        create(:comment, post: first_comment.post)
        expect(Comment.count).to eq(3)

        # Page 1 will return 2 records
        get api_v1_post_comments_url(first_comment.post.id), params: { page: 1 }
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response.count).to eq(2)

        # Page 2 will return 1 record only as we created only 3 records
        get api_v1_post_comments_url(first_comment.post.id), params: { page: 2 }
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response.count).to eq(1)
      end

      it 'does not returns error if no comments exist' do
        get api_v1_post_comments_url(create(:post).id)

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response.count).to eq(0)
        expect(json_response).to eq([])
      end
    end

    context 'with invalid post' do
      it 'returns error with invalid post id' do
        expect do
          get api_v1_post_comments_url(123)
        end
          .to raise_error(ActiveRecord::RecordNotFound, 'Post does not exist')
      end

      it 'returns error with nil post' do
        expect do
          get api_v1_post_comments_url(nil)
        end
          .to raise_error(ActionController::UrlGenerationError)
      end
    end
  end
end
