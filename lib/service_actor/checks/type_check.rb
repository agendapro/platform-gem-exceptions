# frozen_string_literal: true

module ServiceActor
  module Checks
    # ServiceActor::Checks::TypeCheck
    class TypeCheck
      # :nocov:
      remove_const(:DEFAULT_MESSAGE) if const_defined?(:DEFAULT_MESSAGE)
      # :nocov:

      DEFAULT_MESSAGE = ->(input_key:, **) { Platform::ErrorMessage.new('invalid_format', input_key).to_json }
    end
  end
end
