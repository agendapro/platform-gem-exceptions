# frozen_string_literal: true

module Platform
  # Platform::ExceptionHandler
  module ExceptionHandler
    extend ActiveSupport::Concern

    included do
      # priority from bottom to top
      rescue_from(StandardError) { |e| handle_with_handler(e, Platform::ExceptionHandlers::StandardError) }
      rescue_from(ServiceActor::ArgumentError) { |e| handle_with_handler(e, Platform::ExceptionHandlers::ArgumentError) }
      rescue_from(ServiceActor::Failure) { |e| handle_with_handler(e, Platform::ExceptionHandlers::Failure) }
      rescue_from(ActiveRecord::RecordInvalid) { |e| handle_with_handler(e, Platform::ExceptionHandlers::RecordInvalid) }
      rescue_from(ActiveRecord::RecordNotFound) { |e| handle_with_handler(e, Platform::ExceptionHandlers::RecordNotFound) }
      rescue_from(ActiveRecord::RecordNotUnique) { |e| handle_with_handler(e, Platform::ExceptionHandlers::RecordNotUnique) }

      # :nocov:
      if defined?(RequestMigrations::UnsupportedVersionError)
        rescue_from(RequestMigrations::UnsupportedVersionError) { |e| handle_with_handler(e, Platform::ExceptionHandlers::UnsupportedVersion) }
      end
      # :nocov:
    end

    private

    def handle_with_handler(exception, handler_class)
      handler = handler_class.new(exception)
      handler.log
      render json: handler.body, status: handler.status
    end
  end
end
