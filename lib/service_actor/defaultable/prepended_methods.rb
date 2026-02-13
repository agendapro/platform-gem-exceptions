# frozen_string_literal: true

# Suppress Defaultable's plain-text error for missing inputs.
# When a required key is absent, Defaultable falls through and sets it to nil,
# then NilCheck raises with the standardized JSON format from the gem.
module ServiceActor
  module Defaultable
    # ServiceActor::Defaultable::PrependedMethods
    module PrependedMethods
      private

      def raise_error_with(_message) = nil
    end
  end
end
