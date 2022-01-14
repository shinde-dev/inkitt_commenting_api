# frozen_string_literal: true

module Api
  module V1
    class RepliesController < ApplicationController
      before_action :find_post!, only: [:index]

      def index
        replies = Comments::FindWithReplies.run(comment: find_comment!, page: params[:page]).result
        render_response('success', :ok, replies, CommentSerializer)
      end

      private

      def find_post!
        find_record!(Posts, params[:post_id])
      end

      def find_comment!
        find_record!(Comments, params[:comment_id])
      end
    end
  end
end
