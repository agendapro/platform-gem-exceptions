# frozen_string_literal: true

require_relative "core/version"
require 'service_actor'
require_relative "../service_actor/checks/nil_check"
require_relative "error_message"
require_relative "service"

module Platform
  module Core
    class Error < StandardError; end
  end
end
