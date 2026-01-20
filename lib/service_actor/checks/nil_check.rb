# frozen_string_literal: true

require "service_actor/checks/nil_check"

# Override default message for nil check
module ServiceActor
  module Checks
    class NilCheck
      remove_const(:DEFAULT_MESSAGE) if const_defined?(:DEFAULT_MESSAGE)

      DEFAULT_MESSAGE = ->(input_key:, **) { Platform::ErrorMessage.new("required", input_key).to_json }
    end
  end
end
