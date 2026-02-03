# frozen_string_literal: true

require 'delegate'

module Platform
  # Platform::NewRelicError
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
