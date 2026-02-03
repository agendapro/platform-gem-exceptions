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
          detail: snakecase(@exception.model)
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

      def snakecase(string)
        string
          .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
          .gsub(/([a-z\d])([A-Z])/, '\1_\2')
          .downcase
      end
    end
  end
end
