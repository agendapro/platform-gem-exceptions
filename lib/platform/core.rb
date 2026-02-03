# frozen_string_literal: true

require 'active_support/concern'
require 'service_actor'
require_relative '../service_actor/checks/inclusion_check'
require_relative '../service_actor/checks/nil_check'
require_relative '../service_actor/checks/type_check'
require_relative 'exceptions/version'
require_relative 'error_message'
require_relative 'exception_handler'
require_relative 'exception_handlers/argument_error'
require_relative 'exception_handlers/failure'
require_relative 'exception_handlers/record_invalid'
require_relative 'exception_handlers/record_not_found'
require_relative 'exception_handlers/standard_error'
require_relative 'newrelic_error'

module Platform
  # Platform::Exceptions
  module Exceptions
    class Error < StandardError; end
  end
end
