# frozen_string_literal: true

module Platform
  module ExceptionHandlers
    # Platform::ExceptionHandlers::Failure
    class Failure
      def initialize(exception)
        @exception = exception
        freeze
      end

      def body
        {
          error: @exception.result[:error],
          detail: @exception.result[:detail]
        }
      end

      def status
        @exception.result[:status] || :unprocessable_content
      end

      def log
        NewRelic::Agent.notice_error(@exception)
        Rails.logger.error "ExceptionHandler(#{status}): #{@exception.inspect}"
        Rails.logger.error @exception.backtrace.join("\n")
      end
    end
  end
end
