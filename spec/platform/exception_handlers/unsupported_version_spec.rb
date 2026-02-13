# frozen_string_literal: true

RSpec.describe Platform::ExceptionHandlers::UnsupportedVersion do
  subject(:handler) { described_class.new(exception) }

  let(:exception) { instance_double(RequestMigrations::UnsupportedVersionError, message: '2025-01-01', backtrace: ['line1']) }

  describe '#body' do
    it 'returns invalid_header with api_version' do
      expect(handler.body).to eq(error: :invalid_header, detail: :api_version)
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

      expect(NewRelic::Agent).to have_received(:notice_error).with(
        an_instance_of(Platform::NewRelicError).and(having_attributes(message: 'invalid_header_api_version'))
      )
      expect(logger).to have_received(:error).twice
    end
  end
end
