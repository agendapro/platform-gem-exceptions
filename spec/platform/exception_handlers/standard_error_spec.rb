# frozen_string_literal: true

RSpec.describe Platform::ExceptionHandlers::StandardError do
  subject(:handler) { described_class.new(exception) }

  let(:exception) { instance_double(StandardError, message: 'Something went wrong', backtrace: ['line1']) }

  describe '#body' do
    it 'returns internal_error with message' do
      expect(handler.body).to eq(error: :internal_error, detail: 'Something went wrong')
    end
  end

  describe '#status' do
    it 'returns :internal_server_error' do
      expect(handler.status).to eq(:internal_server_error)
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

      expect(NewRelic::Agent).to have_received(:notice_error).with(
        an_instance_of(Platform::NewRelicError).and(having_attributes(message: 'internal_error_Something went wrong'))
      )
      expect(logger).to have_received(:error).twice
    end
  end
end
