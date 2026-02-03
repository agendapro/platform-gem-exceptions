# frozen_string_literal: true

RSpec.describe Platform::ExceptionHandlers::RecordNotFound do
  subject(:handler) { described_class.new(exception) }

  let(:exception) { double('RecordNotFound', model: 'LocationTime', backtrace: ['line1']) }

  describe '#body' do
    it 'returns not_found error with model name' do
      expect(handler.body).to eq(error: :not_found, detail: 'location_time')
    end
  end

  describe '#status' do
    it 'returns :not_found' do
      expect(handler.status).to eq(:not_found)
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
        an_instance_of(Platform::NewRelicError).and(having_attributes(message: 'not_found_location_time'))
      )
      expect(logger).to have_received(:error).twice
    end
  end
end
