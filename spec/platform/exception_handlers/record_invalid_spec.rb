# frozen_string_literal: true

RSpec.describe Platform::ExceptionHandlers::RecordInvalid do
  subject(:handler) { described_class.new(exception) }

  let(:error) { ActiveModel::Error.new(:email) }
  let(:errors) { ActiveModel::Errors.new([error]) }
  let(:record) { double('Record', errors:) }
  let(:exception) { double('RecordInvalid', record:, backtrace: ['line1']) }

  describe '#body' do
    it 'returns invalid_format error with attribute' do
      expect(handler.body).to eq(error: :invalid_format, detail: 'email')
    end
  end

  describe '#status' do
    it 'returns :unprocessable_content' do
      expect(handler.status).to eq(:unprocessable_content)
    end
  end

  describe '#log' do
    let(:logger) { instance_double(Logger, error: nil) }

    before do
      allow(NewRelic::Agent).to receive(:notice_error)
      allow(Rails).to receive(:logger).and_return(logger)
    end

    it 'logs the error' do
      handler.log

      expect(NewRelic::Agent).to have_received(:notice_error).with(exception)
      expect(logger).to have_received(:error).twice
    end
  end
end
