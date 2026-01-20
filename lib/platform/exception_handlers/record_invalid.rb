# frozen_string_literal: true

module Platform
  module ExceptionHandlers
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
        :unprocessable_content
      end

      def log
        NewRelic::Agent.notice_error(@exception)
        Rails.logger.error "ExceptionHandler(unprocessable_content): #{@exception.inspect}"
        Rails.logger.error @exception.backtrace.join("\n")
      end
    end
  end
end
