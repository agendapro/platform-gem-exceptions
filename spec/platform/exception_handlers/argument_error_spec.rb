# frozen_string_literal: true

RSpec.describe Platform::ExceptionHandlers::ArgumentError do
  subject(:handler) { described_class.new(exception) }

  let(:message) { { error: 'required', detail: 'email' } }
  let(:exception) { instance_double(ServiceActor::ArgumentError, message:, backtrace: ['line1']) }

  describe '#body' do
    it 'returns the exception message' do
      expect(handler.body).to eq(message)
    end
  end

  describe '#status' do
    it 'returns :bad_request' do
      expect(handler.status).to eq(:bad_request)
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
