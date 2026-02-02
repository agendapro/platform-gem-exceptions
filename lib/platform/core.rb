# frozen_string_literal: true

require_relative 'core/version'
require 'service_actor'
require 'active_support/concern'
require_relative 'client_validation'
require_relative 'error_message'
require_relative '../service_actor/checks/nil_check'
require_relative 'service'
require_relative 'exception_handlers/argument_error'
require_relative 'exception_handlers/failure'
require_relative 'exception_handlers/record_invalid'
require_relative 'exception_handlers/record_not_found'
require_relative 'exception_handlers/standard_error'
require_relative 'exception_handler'

module Platform
  # Platform::Core
  module Core
    class Error < StandardError; end
  end
end
