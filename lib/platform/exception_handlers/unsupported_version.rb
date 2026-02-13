# frozen_string_literal: true

module Platform
  module ExceptionHandlers
    # Platform::ExceptionHandlers::UnsupportedVersion
    class UnsupportedVersion
      def initialize(exception)
        @exception = exception
        freeze
      end

      def body
        {
          error: :invalid_header,
          detail: :api_version
        }
      end

      def status
        :bad_request
      end

      def log
        newrelic_error = Platform::NewRelicError.new(body, @exception)
        NewRelic::Agent.notice_error(newrelic_error)
        Rails.logger.error "ExceptionHandler(bad_request): #{@exception.inspect}"
        Rails.logger.error @exception.backtrace.join("\n")
      end
    end
  end
end
