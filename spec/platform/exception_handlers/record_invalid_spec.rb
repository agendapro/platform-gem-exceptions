# frozen_string_literal: true

RSpec.describe Platform::ExceptionHandlers::RecordInvalid do
  subject(:handler) { described_class.new(exception) }

  let(:error) { ActiveModel::Error.new(:email, error_type) }
  let(:errors) { ActiveModel::Errors.new([error]) }
  let(:record) { double('Record', errors:) }
  let(:exception) { double('RecordInvalid', record:, backtrace: ['line1']) }

  context 'when error type is :taken' do
    let(:error_type) { :taken }

    describe '#body' do
      it 'returns taken error with attribute' do
        expect(handler.body).to eq(error: :taken, detail: 'email')
      end
    end

    describe '#status' do
      it 'returns :unprocessable_content' do
        expect(handler.status).to eq(:unprocessable_content)
      end
    end
  end

  context 'when error type is :blank' do
    let(:error_type) { :blank }

    describe '#body' do
      it 'returns required error with attribute' do
        expect(handler.body).to eq(error: :required, detail: 'email')
      end
    end

    describe '#status' do
      it 'returns :bad_request' do
        expect(handler.status).to eq(:bad_request)
      end
    end
  end

  context 'when error type is unknown' do
    let(:error_type) { :too_long }

    describe '#body' do
      it 'returns invalid_format error with attribute' do
        expect(handler.body).to eq(error: :invalid_format, detail: 'email')
      end
    end

    describe '#status' do
      it 'returns :bad_request' do
        expect(handler.status).to eq(:bad_request)
      end
    end
  end

  describe '#log' do
    let(:error_type) { :taken }
    let(:logger) { instance_double(Logger, error: nil) }

    before do
      allow(NewRelic::Agent).to receive(:notice_error)
      allow(Rails).to receive(:logger).and_return(logger)
    end

    it 'logs the error' do
      handler.log

      expect(NewRelic::Agent).to have_received(:notice_error).with(
        an_instance_of(Platform::NewRelicError).and(having_attributes(message: 'taken_email'))
      )
      expect(logger).to have_received(:error).twice
    end
  end
end
