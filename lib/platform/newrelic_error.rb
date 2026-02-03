# frozen_string_literal: true

require 'delegate'

module Platform
  # Platform::NewRelicError
  # Wraps an exception with a custom message while preserving the original class for NewRelic grouping.
  class NewRelicError < SimpleDelegator
    def initialize(message, original_exception)
      @message = message
      super(original_exception)
    end

    def message
      "#{@message[:error]}_#{@message[:detail]}"
    end

    def to_s
      "#{@message[:error]}_#{@message[:detail]}"
    end

    def class
      __getobj__.class
    end
  end
end
