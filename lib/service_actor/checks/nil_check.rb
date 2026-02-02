# frozen_string_literal: true

require 'service_actor/checks/inclusion_check'
require 'service_actor/checks/nil_check'
require 'service_actor/checks/type_check'

module ServiceActor
  module Checks
    # ServiceActor::Checks::InclusionCheck
    class InclusionCheck
      # :nocov:
      remove_const(:DEFAULT_MESSAGE) if const_defined?(:DEFAULT_MESSAGE)
      # :nocov:

      DEFAULT_MESSAGE = ->(input_key:, **) { Platform::ErrorMessage.new('invalid_format', input_key).to_json }
    end

    # ServiceActor::Checks::NilCheck
    class NilCheck
      # :nocov:
      remove_const(:DEFAULT_MESSAGE) if const_defined?(:DEFAULT_MESSAGE)
      # :nocov:

      DEFAULT_MESSAGE = ->(input_key:, **) { Platform::ErrorMessage.new('required', input_key).to_json }
    end

    # ServiceActor::Checks::TypeCheck
    class TypeCheck
      # :nocov:
      remove_const(:DEFAULT_MESSAGE) if const_defined?(:DEFAULT_MESSAGE)
      # :nocov:

      DEFAULT_MESSAGE = ->(input_key:, **) { Platform::ErrorMessage.new('invalid_format', input_key).to_json }
    end
  end
end
