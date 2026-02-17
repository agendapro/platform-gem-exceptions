# frozen_string_literal: true

RSpec.describe 'ServiceActor::Defaultable override' do
  describe 'PrependedMethods#raise_error_with' do
    let(:actor_class) do
      build_actor do
        input :name, type: String
        def call; end
      end
    end

    it 'raises ArgumentError with standardized JSON for missing input', :aggregate_failures do
      error = begin
        actor_class.call
      rescue ServiceActor::ArgumentError => e
        e
      end

      expect(error).to be_a(ServiceActor::ArgumentError)

      parsed = JSON.parse(error.message, symbolize_names: true)
      expect(parsed).to eq(error: 'required', detail: 'name')
    end

    it 'falls back to message when input_key cannot be determined', :aggregate_failures do
      result = ServiceActor::Result.new(name: 'present')
      actor = actor_class.new(result)

      error = begin
        actor.send(:raise_error_with, 'fallback_detail')
      rescue ServiceActor::ArgumentError => e
        e
      end

      expect(error).to be_a(ServiceActor::ArgumentError)

      parsed = JSON.parse(error.message, symbolize_names: true)
      expect(parsed).to eq(error: 'required', detail: 'fallback_detail')
    end
  end
end
