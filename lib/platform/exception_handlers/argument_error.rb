# frozen_string_literal: true

module Platform
  module ExceptionHandlers
    # Platform::ExceptionHandlers::ArgumentError
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
        newrelic_error = Platform::NewRelicError.new(newrelic_body, @exception)
        NewRelic::Agent.notice_error(newrelic_error)
        Rails.logger.error "ExceptionHandler(bad_request): #{@exception.inspect}"
        Rails.logger.error @exception.backtrace.join("\n")
      end

      def newrelic_body
        ErrorMessage.from_json(body).to_h
      end
    end
  end
end
