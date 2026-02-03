# frozen_string_literal: true

module Platform
  module ExceptionHandlers
    # Platform::ExceptionHandlers::RecordNotFound
    class RecordNotFound
      def initialize(exception)
        @exception = exception
        freeze
      end

      def body
        {
          error: :not_found,
          detail: @exception.model.downcase
        }
      end

      def status
        :not_found
      end

      def log
        newrelic_error = Platform::NewRelicError.new(body, @exception)
        NewRelic::Agent.notice_error(newrelic_error)
        Rails.logger.error "ExceptionHandler(not_found): #{@exception.inspect}"
        Rails.logger.error @exception.backtrace.join("\n")
      end
    end
  end
end
