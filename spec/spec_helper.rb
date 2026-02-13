# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'logger'
require 'uri'
require 'active_support/core_ext/object/blank'
require 'bigdecimal'
require 'bigdecimal/util'

# Mock Rails and dependencies before loading platform/exceptions
module Rails
  def self.logger
    @logger ||= Logger.new(nil)
  end
end

module NewRelic
  module Agent
    def self.notice_error(_exception); end
    def self.add_custom_attributes(**_attrs); end
  end
end

module ActiveRecord
  class Base; end

  class RecordInvalid < StandardError
    attr_reader :record

    def initialize(record = nil)
      @record = record
      super()
    end
  end

  class RecordNotFound < StandardError
    attr_reader :model

    def initialize(model = nil)
      @model = model
      super()
    end
  end
end

module ActiveModel
  class Error
    attr_reader :attribute

    def initialize(attribute = nil)
      @attribute = attribute
    end
  end

  class Errors
    attr_reader :errors

    def initialize(errors = [])
      @errors = errors
    end

    def first
      @errors.first
    end
  end
end

module Settings
  def self.client_names
    []
  end
end

module RequestMigrations
  class UnsupportedVersionError < StandardError; end
end

require 'platform/exceptions'

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
