# frozen_string_literal: true

RSpec.describe Platform::Service do
  def validator_passes?(validator_hash, value)
    validator_hash.values.first[:is].call(value)
  end

  def validator_message(validator_hash, input_key)
    JSON.parse(validator_hash.values.first[:message].call(input_key:), symbolize_names: true)
  end

  shared_examples 'returns invalid_format message' do
    it 'returns invalid_format error message' do
      expect(validator_message(validator, :field)).to eq(error: 'invalid_format', detail: 'field')
    end
  end

  describe '.be_array_of_integers_or_nil' do
    let(:validator) { described_class.be_array_of_integers_or_nil }

    it { expect(validator_passes?(validator, nil)).to be true }
    it { expect(validator_passes?(validator, [1, 2, 3])).to be true }
    it { expect(validator_passes?(validator, [])).to be true }
    it { expect(validator_passes?(validator, ['a'])).to be false }
    it { expect(validator_passes?(validator, [-1])).to be false }

    include_examples 'returns invalid_format message'
  end

  describe '.be_date_or_nil' do
    let(:validator) { described_class.be_date_or_nil }

    it { expect(validator_passes?(validator, nil)).to be true }
    it { expect(validator_passes?(validator, '2024-01-15')).to be_truthy }
    it { expect(validator_passes?(validator, 'invalid')).to be false }

    include_examples 'returns invalid_format message'
  end

  describe '.be_datetime' do
    let(:validator) { described_class.be_datetime }

    it { expect(validator_passes?(validator, '2024-01-15T10:30:00Z')).to be_truthy }
    it { expect(validator_passes?(validator, 'invalid')).to be false }

    include_examples 'returns invalid_format message'
  end

  describe '.be_email' do
    let(:validator) { described_class.be_email }

    it { expect(validator_passes?(validator, 'test@example.com')).to be_truthy }
    it { expect(validator_passes?(validator, 'invalid')).to be_falsey }

    include_examples 'returns invalid_format message'
  end

  describe '.be_email_or_nil' do
    let(:validator) { described_class.be_email_or_nil }

    it { expect(validator_passes?(validator, nil)).to be true }
    it { expect(validator_passes?(validator, 'test@example.com')).to be true }
    it { expect(validator_passes?(validator, 'invalid')).to be false }

    include_examples 'returns invalid_format message'
  end

  describe '.be_in_range' do
    let(:validator) { described_class.be_in_range(1, 10) }

    it { expect(validator_passes?(validator, '5')).to be true }
    it { expect(validator_passes?(validator, '1')).to be true }
    it { expect(validator_passes?(validator, '10')).to be true }
    it { expect(validator_passes?(validator, '0')).to be false }
    it { expect(validator_passes?(validator, '11')).to be false }

    include_examples 'returns invalid_format message'
  end

  describe '.be_non_negative' do
    let(:validator) { described_class.be_non_negative }

    it { expect(validator_passes?(validator, '0')).to be true }
    it { expect(validator_passes?(validator, '5')).to be true }
    it { expect(validator_passes?(validator, '-1')).to be false }

    include_examples 'returns invalid_format message'
  end

  describe '.be_non_negative_amount' do
    let(:validator) { described_class.be_non_negative_amount }

    it { expect(validator_passes?(validator, '0.00')).to be true }
    it { expect(validator_passes?(validator, '10.50')).to be true }
    it { expect(validator_passes?(validator, '-1.00')).to be false }

    include_examples 'returns invalid_format message'
  end

  describe '.be_non_negative_or_nil' do
    let(:validator) { described_class.be_non_negative_or_nil }

    it { expect(validator_passes?(validator, nil)).to be true }
    it { expect(validator_passes?(validator, 0)).to be true }
    it { expect(validator_passes?(validator, 5)).to be true }
    it { expect(validator_passes?(validator, -1)).to be false }

    include_examples 'returns invalid_format message'
  end

  describe '.be_phone' do
    let(:validator) { described_class.be_phone }

    it { expect(validator_passes?(validator, '+12025551234')).to be true }
    it { expect(validator_passes?(validator, '+442071234567')).to be true }
    it { expect(validator_passes?(validator, '12025551234')).to be false }
    it { expect(validator_passes?(validator, 'invalid')).to be false }

    include_examples 'returns invalid_format message'
  end

  describe '.be_phone_or_blank' do
    let(:validator) { described_class.be_phone_or_blank }

    it { expect(validator_passes?(validator, nil)).to be true }
    it { expect(validator_passes?(validator, '')).to be true }
    it { expect(validator_passes?(validator, '+12025551234')).to be true }
    it { expect(validator_passes?(validator, '12025551234')).to be false }
    it { expect(validator_passes?(validator, 'invalid')).to be false }

    include_examples 'returns invalid_format message'
  end

  describe '.be_positive_or_nil' do
    let(:validator) { described_class.be_positive_or_nil }

    it { expect(validator_passes?(validator, nil)).to be true }
    it { expect(validator_passes?(validator, 5)).to be true }
    it { expect(validator_passes?(validator, 0)).to be false }
    it { expect(validator_passes?(validator, -1)).to be false }

    include_examples 'returns invalid_format message'
  end

  describe '.be_present' do
    let(:validator) { described_class.be_present }

    it { expect(validator_passes?(validator, 'value')).to be true }
    it { expect(validator_passes?(validator, nil)).to be false }
    it { expect(validator_passes?(validator, '')).to be false }

    it 'returns required error message' do
      expect(validator_message(validator, :field)).to eq(error: 'required', detail: 'field')
    end
  end

  describe '.max_length' do
    let(:validator) { described_class.max_length(5) }

    it { expect(validator_passes?(validator, 'abc')).to be true }
    it { expect(validator_passes?(validator, 'abcde')).to be true }
    it { expect(validator_passes?(validator, 'abcdef')).to be false }

    include_examples 'returns invalid_format message'
  end

  describe '.parse_date' do
    it { expect(described_class.parse_date('2024-01-15')).to eq(Date.new(2024, 1, 15)) }
    it { expect(described_class.parse_date('invalid')).to be false }
  end

  describe '.parse_datetime' do
    it { expect(described_class.parse_datetime('2024-01-15T10:30:00Z')).to be_a(Time) }
    it { expect(described_class.parse_datetime('invalid')).to be false }
  end
end
