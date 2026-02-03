# frozen_string_literal: true

RSpec.describe Platform::NewRelicError do
  subject(:error) { described_class.new(custom_message, original_exception) }

  let(:custom_message) { { error: :not_found, detail: 'user' } }
  let(:original_exception) { StandardError.new('Original message') }

  before { original_exception.set_backtrace(%w[line1 line2]) }

  describe '#message' do
    it 'returns formatted error__detail message' do
      expect(error.message).to eq('not_found_user')
    end
  end

  describe '#to_s' do
    it 'returns formatted error__detail message' do
      expect(error.to_s).to eq('not_found_user')
    end
  end

  describe '#class' do
    it 'returns the original exception class' do
      expect(error.class).to eq(StandardError)
    end

    it 'preserves class name for NewRelic grouping' do
      expect(error.class.name).to eq('StandardError')
    end
  end

  describe 'delegation' do
    it 'delegates backtrace to original exception' do
      expect(error.backtrace).to eq(%w[line1 line2])
    end
  end
end
