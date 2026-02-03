# frozen_string_literal: true

RSpec.describe Platform::ExceptionHandlers::Failure do
  subject(:handler) { described_class.new(exception) }

  let(:result) { { error: 'cross_company', detail: 'provider', status: } }
  let(:status) { :im_a_teapot }
  let(:exception) { instance_double(ServiceActor::Failure, result:, backtrace: ['line1']) }

  describe '#body' do
    it 'returns error and detail from result' do
      expect(handler.body).to eq(error: 'cross_company', detail: 'provider')
    end
  end

  describe '#status' do
    it 'returns status from result' do
      expect(handler.status).to eq(:im_a_teapot)
    end

    context 'when result has no status' do
      let(:status) { nil }

      it 'defaults to :unprocessable_content' do
        expect(handler.status).to eq(:unprocessable_content)
      end
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
        an_instance_of(Platform::NewRelicError).and(having_attributes(message: 'cross_company_provider'))
      )
      expect(logger).to have_received(:error).twice
    end
  end
end
