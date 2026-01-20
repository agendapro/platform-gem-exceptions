# frozen_string_literal: true

module Platform
  class Service < Actor
    def self.be_positive_or_nil
      {
        be_positive_or_nil: {
          is: ->(v) { v.nil? || v.to_i.positive? },
          message: ->(input_key:, **) { "invalid_#{input_key}" }
        }
      }
    end

    def self.be_present
      {
        be_present: {
          is: ->(v) { v.present? },
          message: ->(input_key:, **) { "invalid_#{input_key}" }
        }
      }
    end
  end
end
