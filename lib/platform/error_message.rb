# frozen_string_literal: true

module Platform
  class ErrorMessage
    def initialize(error, detail)
      @error = error
      @detail = detail
      freeze
    end

    def to_json
      {
        error: @error,
        detail: @detail
      }.to_json
    end

    def from_json(json)
      JSON.parse(json, symbol_keys: true).then do |data|
        new(data[:error], data[:detail])
      end
    end
  end
end
