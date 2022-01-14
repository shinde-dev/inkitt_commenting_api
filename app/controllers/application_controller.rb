# frozen_string_literal: true

class ApplicationController < ActionController::API
  include JsonResponses
  include InteractionsHelper
end
