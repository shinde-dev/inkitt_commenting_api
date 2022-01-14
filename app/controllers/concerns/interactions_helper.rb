# frozen_string_literal: true

module InteractionsHelper
  extend ActiveSupport::Concern

  def find_record!(module_name, id)
    outcome = module_name::Find.run({ id: id })
    raise ActiveRecord::RecordNotFound, outcome.errors.full_messages.to_sentence unless outcome.valid?

    outcome.result
  end
end
