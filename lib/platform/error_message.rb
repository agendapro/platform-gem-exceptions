# frozen_string_literal: true

module Platform
  # Platform::ErrorMessage
  class ErrorMessage
    def initialize(error, detail)
      @error = error
      @detail = detail
      freeze
    end

    def to_json(*_args)
      {
        error: @error,
        detail: @detail
      }.to_json
    end

    def self.from_json(json)
      JSON.parse(json, symbolize_names: true).then do |data|
        new(data[:error], data[:detail])
      end
    end
  end
end
