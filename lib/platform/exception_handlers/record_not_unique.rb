# frozen_string_literal: true

module Platform
  module ExceptionHandlers
    # Platform::ExceptionHandlers::RecordNotUnique
    class RecordNotUnique
      def initialize(exception)
        @exception = exception
        freeze
      end

      def body
        { error: :taken, detail: column_from_message }
      end

      def status
        :unprocessable_content
      end

      def log
        newrelic_error = Platform::NewRelicError.new(body, @exception)
        NewRelic::Agent.notice_error(newrelic_error)
        Rails.logger.error "ExceptionHandler(taken): #{@exception.inspect}"
        Rails.logger.error @exception.backtrace.join("\n")
      end

      private

      def column_from_message
        match = @exception.message.match(/Key \((.+?)\)=/)
        return 'record' unless match

        match[1].gsub(/,\s*/, '_and_')
      end
    end
  end
end
