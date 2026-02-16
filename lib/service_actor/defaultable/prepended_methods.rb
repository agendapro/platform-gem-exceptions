# frozen_string_literal: true

# Translate Defaultable's plain-text error for missing inputs
# into the standardized JSON format used across the platform.
module ServiceActor
  module Defaultable
    # ServiceActor::Defaultable::PrependedMethods
    module PrependedMethods
      private

      def raise_error_with(message)
        input_key = self.class.inputs.keys.find { |key| !result.key?(key) }

        raise self.class.argument_error_class,
              Platform::ErrorMessage.new('required', input_key || message).to_json
      end
    end
  end
end
