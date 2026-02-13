# frozen_string_literal: true

RSpec.describe Platform::ExceptionHandler do
  let(:controller_class) do
    Class.new do
      def self.rescue_from(*_args); end

      include Platform::ExceptionHandler

      attr_accessor :rendered_response

      def render(options)
        @rendered_response = options
      end
    end
  end

  let(:controller) { controller_class.new }

  describe '#handle_with_handler' do
    let(:exception) { StandardError.new('test error') }
    let(:logger) { instance_double(Logger, error: nil) }

    before do
      allow(NewRelic::Agent).to receive(:notice_error)
      allow(Rails).to receive(:logger).and_return(logger)
      allow(exception).to receive(:backtrace).and_return(['line1'])
    end

    it 'logs the exception and renders the response' do
      controller.send(:handle_with_handler, exception, Platform::ExceptionHandlers::StandardError)

      expect(controller.rendered_response).to eq(
        json: { error: :internal_error, detail: 'test error' },
        status: :internal_server_error
      )
    end
  end

  describe 'rescue_from setup' do
    it 'registers handlers for expected exceptions' do
      registered_handlers = []

      Class.new do
        define_singleton_method(:rescue_from) do |exception_class, &_block|
          registered_handlers << exception_class
        end

        include Platform::ExceptionHandler
      end

      expect(registered_handlers).to contain_exactly(
        StandardError,
        ServiceActor::ArgumentError,
        ServiceActor::Failure,
        ActiveRecord::RecordInvalid,
        ActiveRecord::RecordNotUnique,
        ActiveRecord::RecordNotFound,
        RequestMigrations::UnsupportedVersionError
      )
    end
  end
end
