# frozen_string_literal: true

RSpec.describe Platform::ClientValidation do
  let(:controller_class) do
    Class.new do
      def self.before_action(_method); end

      include Platform::ClientValidation

      attr_accessor :request, :rendered_response

      def render(options)
        @rendered_response = options
      end
    end
  end

  let(:controller) { controller_class.new }
  let(:headers) { { 'X-Client-Name' => client_name } }
  let(:request) { double('Request', headers: headers) }

  before do
    controller.request = request
  end

  describe '#validate_client_name' do
    context 'when client name is valid' do
      let(:client_name) { 'valid_client' }

      before do
        allow(Settings).to receive(:client_names).and_return(['valid_client'])
        allow(NewRelic::Agent).to receive(:add_custom_attributes)
      end

      it 'adds client_name to NewRelic attributes' do
        controller.send(:validate_client_name)

        expect(NewRelic::Agent).to have_received(:add_custom_attributes).with(client_name: 'valid_client')
      end

      it 'does not render an error' do
        controller.send(:validate_client_name)

        expect(controller.rendered_response).to be_nil
      end
    end

    context 'when client name is invalid' do
      let(:client_name) { 'unknown_client' }

      before do
        allow(Settings).to receive(:client_names).and_return(['valid_client'])
      end

      it 'renders unauthorized response' do
        controller.send(:validate_client_name)

        expect(controller.rendered_response).to eq(
          json: { error: 'invalid_client', detail: 'header' },
          status: :unauthorized
        )
      end
    end

    context 'when client name header is missing' do
      let(:client_name) { nil }

      before do
        allow(Settings).to receive(:client_names).and_return(['valid_client'])
      end

      it 'renders unauthorized response' do
        controller.send(:validate_client_name)

        expect(controller.rendered_response).to eq(
          json: { error: 'invalid_client', detail: 'header' },
          status: :unauthorized
        )
      end
    end
  end
end
