# frozen_string_literal: true

Kaminari.configure do |config|
  config.default_per_page = ENV.fetch("PER_PAGE_LIMIT")
end
