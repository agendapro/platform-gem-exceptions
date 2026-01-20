# frozen_string_literal: true

require_relative "core/version"
require 'service_actor'
require_relative "error_message"
require_relative "../service_actor/checks/nil_check"
require_relative "service"
require_relative "exception_handlers/standard_error"
require_relative "exception_handlers/argument_error"

module Platform
  module Core
    class Error < StandardError; end
  end
end
