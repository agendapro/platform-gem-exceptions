# frozen_string_literal: true

module Platform
  module ExceptionHandlers
    # Platform::ExceptionHandlers::RecordInvalid
    class RecordInvalid
      STATUS_MAP = {
        taken: :unprocessable_content,
        blank: :bad_request
      }.freeze

      ERROR_MAP = {
        taken: :taken,
        blank: :required
      }.freeze

      def initialize(exception)
        @exception = exception
        freeze
      end

      def body
        {
          error: ERROR_MAP.fetch(error_type, :invalid_format),
          detail: @exception.record.errors.first.attribute.to_s
        }
      end

      def status
        STATUS_MAP.fetch(error_type, :bad_request)
      end

      def log
        newrelic_error = Platform::NewRelicError.new(body, @exception)
        NewRelic::Agent.notice_error(newrelic_error)
        Rails.logger.error "ExceptionHandler(#{status}): #{@exception.inspect}"
        Rails.logger.error @exception.backtrace.join("\n")
      end

      private

      def error_type
        @exception.record.errors.first.type
      end
    end
  end
end
