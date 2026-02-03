# frozen_string_literal: true

module Platform
  module ExceptionHandlers
    # Platform::ExceptionHandlers::RecordInvalid
    class RecordInvalid
      def initialize(exception)
        @exception = exception
        freeze
      end

      def body
        {
          error: :invalid_format,
          detail: @exception.record.errors.first.attribute.to_s
        }
      end

      def status
        :bad_request
      end

      def log
        newrelic_error = Platform::NewRelicError.new(body, @exception)
        NewRelic::Agent.notice_error(newrelic_error)
        Rails.logger.error "ExceptionHandler(unprocessable_content): #{@exception.inspect}"
        Rails.logger.error @exception.backtrace.join("\n")
      end
    end
  end
end
