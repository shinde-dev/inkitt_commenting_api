# frozen_string_literal: true

module Api
  module V1
    class CommentsController < ApplicationController
      def create
        inputs = { post: find_post! }.reverse_merge(comment_params)
        comment = Comments::Create.run(inputs)

        if comment.valid?
          render_success_response('created', CommentSerializer, comment.result)
        else
          render_error_response(comment.errors.full_messages.to_sentence)
        end
      end

      private

      def find_post!
        post = Posts::Find.run({ id: params[:post_id] })
        raise ActiveRecord::RecordNotFound, post.errors.full_messages.to_sentence unless post.valid?

        post.result
      end

      def comment_params
        params.require(:comment).permit(:parent_id, :body)
      end
    end
  end
end
