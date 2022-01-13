# frozen_string_literal: true

module Api
  module V1
    class CommentsController < ApplicationController
      before_action :find_post!, only: :update

      def create
        inputs = { post: find_post! }.reverse_merge(comment_params)
        comment = Comments::Create.run(inputs)

        if comment.valid?
          render_success_response('created', CommentSerializer, comment.result)
        else
          render_error_response(comment.errors.full_messages.to_sentence)
        end
      end

      def update
        inputs = { comment: find_comment! }.reverse_merge(comment_params.except(:parent_id))
        comment = Comments::Update.run(inputs)

        if comment.valid?
          render_response('updated', :ok, comment.result, CommentSerializer)
        else
          render_error_response(comment.errors.full_messages.to_sentence)
        end
      end

      def index
        comments = Comments::List.run(post: find_post!, page: params[:page]).result
        render_response('success', :ok, comments, CommentSerializer)
      end

      private

      def find_post!
        find_record!(Posts, params[:post_id])
      end

      def find_comment!
        find_record!(Comments, params[:id])
      end

      def comment_params
        params.require(:comment).permit(:parent_id, :body)
      end
    end
  end
end
