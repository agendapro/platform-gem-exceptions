# frozen_string_literal: true

module Platform
  module ExceptionHandlers
    class ArgumentError
      def initialize(exception)
        @exception = exception
        freeze
      end

      def body
        @exception.message
      end

      def status
        :bad_request
      end

      def log
        NewRelic::Agent.notice_error(@exception)
        Rails.logger.error "ExceptionHandler(bad_request): #{@exception.inspect}"
        Rails.logger.error @exception.backtrace.join("\n")
      end
    end
  end
end
