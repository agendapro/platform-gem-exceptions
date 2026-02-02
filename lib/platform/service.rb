# frozen_string_literal: true

module Platform
  # Platform::Service
  class Service < Actor
    E164_REGEX = /\A\+[1-9]\d{1,14}\z/

    def self.be_array_of_integers_or_nil
      {
        be_array_of_integers: {
          is: ->(v) { v.nil? || (v.is_a?(Array) && v.all?(Integer) && v.all?(&:positive?)) },
          message: ->(input_key:, **) { ErrorMessage.new('invalid_format', input_key).to_json }
        }
      }
    end

    def self.be_date_or_nil
      {
        be_date_or_nil: {
          is: ->(v) { v.nil? || parse_date(v) },
          message: ->(input_key:, **) { ErrorMessage.new('invalid_format', input_key).to_json }
        }
      }
    end

    def self.be_datetime
      {
        be_datetime: {
          is: ->(v) { parse_datetime(v) },
          message: ->(input_key:, **) { ErrorMessage.new('invalid_format', input_key).to_json }
        }
      }
    end

    def self.be_email
      {
        be_valid_email: {
          is: ->(v) { v =~ URI::MailTo::EMAIL_REGEXP },
          message: ->(input_key:, **) { ErrorMessage.new('invalid_format', input_key).to_json }
        }
      }
    end

    def self.be_email_or_nil
      {
        be_email_or_nil: {
          is: ->(v) { v.nil? || v.match?(URI::MailTo::EMAIL_REGEXP) },
          message: ->(input_key:, **) { ErrorMessage.new('invalid_format', input_key).to_json }
        }
      }
    end

    def self.be_in_range(min, max)
      {
        be_in_range: {
          is: ->(v) { v.present? && v.to_i.between?(min, max) },
          message: ->(input_key:, **) { ErrorMessage.new('invalid_format', input_key).to_json }
        }
      }
    end

    def self.be_non_negative
      {
        be_non_negative: {
          is: ->(v) { v.present? && (v.to_i.zero? || v.to_i.positive?) },
          message: ->(input_key:, **) { ErrorMessage.new('invalid_format', input_key).to_json }
        }
      }
    end

    def self.be_non_negative_amount
      {
        be_non_negative_amount: {
          is: ->(v) { v.present? && (v.to_d.zero? || v.to_d.positive?) },
          message: ->(input_key:, **) { ErrorMessage.new('invalid_format', input_key).to_json }
        }
      }
    end

    def self.be_non_negative_or_nil
      {
        be_non_negative_or_nil: {
          is: ->(v) { v.to_i.zero? || v.to_i.positive? },
          message: ->(input_key:, **) { ErrorMessage.new('invalid_format', input_key).to_json }
        }
      }
    end

    def self.be_phone
      {
        be_valid_phone: {
          is: ->(v) { v.match?(E164_REGEX) },
          message: ->(input_key:, **) { ErrorMessage.new('invalid_format', input_key).to_json }
        }
      }
    end

    def self.be_phone_or_blank
      {
        be_valid_phone_or_blank: {
          is: ->(v) { v.blank? || v.match?(E164_REGEX) },
          message: ->(input_key:, **) { ErrorMessage.new('invalid_format', input_key).to_json }
        }
      }
    end

    def self.be_positive_or_nil
      {
        be_positive_or_nil: {
          is: ->(v) { v.nil? || v.to_i.positive? },
          message: ->(input_key:, **) { ErrorMessage.new('invalid_format', input_key).to_json }
        }
      }
    end

    def self.be_present
      {
        be_present: {
          is: lambda(&:present?),
          message: ->(input_key:, **) { ErrorMessage.new('required', input_key).to_json }
        }
      }
    end

    def self.max_length(max)
      {
        max_length: {
          is: ->(v) { v.present? && v.length <= max },
          message: ->(input_key:, **) { ErrorMessage.new('invalid_format', input_key).to_json }
        }
      }
    end

    def self.parse_date(date_string)
      Date.parse(date_string)
    rescue StandardError
      false
    end

    def self.parse_datetime(datetime)
      Time.iso8601(datetime)
    rescue StandardError
      false
    end
  end
end
