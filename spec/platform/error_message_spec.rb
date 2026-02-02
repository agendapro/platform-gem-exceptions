# frozen_string_literal: true

RSpec.describe Platform::ErrorMessage do
  subject(:error_message) { described_class.new(error, detail) }

  let(:error) { 'invalid_format' }
  let(:detail) { 'email' }

  describe '#to_json' do
    it 'returns JSON with error and detail' do
      result = JSON.parse(error_message.to_json, symbolize_names: true)

      expect(result).to eq(error: 'invalid_format', detail: 'email')
    end
  end

  describe '.from_json' do
    it 'returns an ErrorMessage object' do
      result = described_class.from_json(error_message.to_json)

      expect(result).to be_a(described_class)
    end
  end
end
