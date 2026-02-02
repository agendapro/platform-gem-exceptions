# frozen_string_literal: true

module Platform
  # Platform::ExceptionHandler
  module ExceptionHandler
    extend ActiveSupport::Concern

    included do
      rescue_from(StandardError) { |e| handle_with_handler(e, Platform::ExceptionHandlers::StandardError) }
      rescue_from(ServiceActor::ArgumentError) { |e| handle_with_handler(e, Platform::ExceptionHandlers::ArgumentError) }
      rescue_from(ServiceActor::Failure) { |e| handle_with_handler(e, Platform::ExceptionHandlers::Failure) }
      rescue_from(ActiveRecord::RecordInvalid) { |e| handle_with_handler(e, Platform::ExceptionHandlers::RecordInvalid) }
      rescue_from(ActiveRecord::RecordNotFound) { |e| handle_with_handler(e, Platform::ExceptionHandlers::RecordNotFound) }
    end

    private

    def handle_with_handler(exception, handler_class)
      handler = handler_class.new(exception)
      handler.log
      render json: handler.body, status: handler.status
    end
  end
end
