# frozen_string_literal: true

module Platform
  module ExceptionHandlers
    # Platform::ExceptionHandlers::StandardError
    class StandardError
      def initialize(exception)
        @exception = exception
        freeze
      end

      def body
        {
          error: :internal_error,
          detail: @exception.message
        }
      end

      def status
        :internal_server_error
      end

      def log
        newrelic_error = Platform::NewRelicError.new(body, @exception)
        NewRelic::Agent.notice_error(newrelic_error)
        Rails.logger.error "ExceptionHandler(internal_error): #{@exception.inspect}"
        Rails.logger.error @exception.backtrace.join("\n")
      end
    end
  end
end
