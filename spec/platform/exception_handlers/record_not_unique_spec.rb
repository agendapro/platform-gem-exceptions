# frozen_string_literal: true

RSpec.describe Platform::ExceptionHandlers::RecordNotUnique do
  subject(:handler) { described_class.new(exception) }

  let(:exception) { double('RecordNotUnique', message:, backtrace: ['line1']) }

  describe '#body' do
    context 'when message contains a single column key' do
      let(:message) { 'PG::UniqueViolation: ERROR: duplicate key value violates unique constraint "index_users_on_email" DETAIL: Key (email)=(test@example.com) already exists.' }

      it 'returns taken error with column name', :aggregate_failures do
        expect(handler.body).to eq(error: :taken, detail: 'email')
      end
    end

    context 'when message contains a composite key' do
      let(:message) { 'PG::UniqueViolation: ERROR: duplicate key value violates unique constraint "index_on_email_phone" DETAIL: Key (email,phone)=(test@example.com,123) already exists.' }

      it 'returns taken error with column names joined by _and_', :aggregate_failures do
        expect(handler.body).to eq(error: :taken, detail: 'email_and_phone')
      end
    end

    context 'when message cannot be parsed' do
      let(:message) { 'PG::UniqueViolation: ERROR: something unexpected' }

      it 'returns taken error with record fallback', :aggregate_failures do
        expect(handler.body).to eq(error: :taken, detail: 'record')
      end
    end
  end

  describe '#status' do
    let(:message) { 'PG::UniqueViolation: ERROR: duplicate key DETAIL: Key (email)=(test@example.com) already exists.' }

    it 'returns :unprocessable_content' do
      expect(handler.status).to eq(:unprocessable_content)
    end
  end

  describe '#log' do
    let(:message) { 'PG::UniqueViolation: ERROR: duplicate key DETAIL: Key (email)=(test@example.com) already exists.' }
    let(:logger) { instance_double(Logger, error: nil) }

    before do
      allow(NewRelic::Agent).to receive(:notice_error)
      allow(Rails).to receive(:logger).and_return(logger)
    end

    it 'logs the error', :aggregate_failures do
      handler.log

      expect(NewRelic::Agent).to have_received(:notice_error).with(
        an_instance_of(Platform::NewRelicError).and(having_attributes(message: 'taken_email'))
      )
      expect(logger).to have_received(:error).twice
    end
  end
end
