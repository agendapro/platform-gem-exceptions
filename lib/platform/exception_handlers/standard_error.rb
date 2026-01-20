# frozen_string_literal: true

module Platform
  module ExceptionHandlers
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
        NewRelic::Agent.notice_error(@exception)
        Rails.logger.error "ExceptionHandler(internal_error): #{@exception.inspect}"
        Rails.logger.error @exception.backtrace.join("\n")
      end

    end
  end
end
