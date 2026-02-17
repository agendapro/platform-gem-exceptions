# frozen_string_literal: true

RSpec.describe 'Defaultable override integration' do
  let(:required_input_actor) do
    build_actor do
      input :name, type: String
      def call; end
    end
  end

  let(:allow_nil_no_default_actor) do
    build_actor do
      input :name, type: String, allow_nil: true
      def call; end
    end
  end

  let(:allow_nil_must_actor) do
    build_actor do
      input :score, type: Integer, allow_nil: true, must: { be_positive: lambda(&:positive?) }
      def call; end
    end
  end

  let(:default_nil_actor) do
    build_actor do
      input :name, type: String, default: nil
      def call; end
    end
  end

  let(:default_value_actor) do
    build_actor do
      input :role, type: String, default: 'user'
      def call; end
    end
  end

  let(:required_must_actor) do
    build_actor do
      input :email, type: String, must: { be_present: ->(v) { !v.nil? && !v.empty? } }
      def call; end
    end
  end

  let(:untyped_actor) do
    build_actor do
      input :data
      def call; end
    end
  end

  describe 'missing required input with type (no default, no allow_nil)' do
    it 'raises ArgumentError with standardized JSON from NilCheck', :aggregate_failures do
      error = begin
        required_input_actor.call
      rescue ServiceActor::ArgumentError => e
        e
      end

      expect(error).to be_a(ServiceActor::ArgumentError)

      parsed = JSON.parse(error.message, symbolize_names: true)
      expect(parsed).to eq(error: 'required', detail: 'name')
    end
  end

  describe 'missing untyped input (no default, no allow_nil, no type)' do
    it 'raises ArgumentError with standardized JSON', :aggregate_failures do
      error = begin
        untyped_actor.call
      rescue ServiceActor::ArgumentError => e
        e
      end

      expect(error).to be_a(ServiceActor::ArgumentError)

      parsed = JSON.parse(error.message, symbolize_names: true)
      expect(parsed).to eq(error: 'required', detail: 'data')
    end
  end

  describe 'missing input with allow_nil: true but no default' do
    it 'raises ArgumentError with standardized JSON', :aggregate_failures do
      error = begin
        allow_nil_no_default_actor.call
      rescue ServiceActor::ArgumentError => e
        e
      end

      expect(error).to be_a(ServiceActor::ArgumentError)

      parsed = JSON.parse(error.message, symbolize_names: true)
      expect(parsed).to eq(error: 'required', detail: 'name')
    end
  end

  describe 'missing input with allow_nil: true, must: check, and no default' do
    it 'raises ArgumentError with standardized JSON', :aggregate_failures do
      error = begin
        allow_nil_must_actor.call
      rescue ServiceActor::ArgumentError => e
        e
      end

      expect(error).to be_a(ServiceActor::ArgumentError)

      parsed = JSON.parse(error.message, symbolize_names: true)
      expect(parsed).to eq(error: 'required', detail: 'score')
    end
  end

  describe 'missing input with default: nil (explicit)' do
    it 'sets value to nil via default (unchanged behavior)', :aggregate_failures do
      result = default_nil_actor.call

      expect(result[:name]).to be_nil
    end
  end

  describe 'missing input with non-nil default' do
    it 'applies the default value (unchanged behavior)', :aggregate_failures do
      result = default_value_actor.call

      expect(result[:role]).to eq('user')
    end
  end

  describe 'missing required input with must: check (no allow_nil)' do
    it 'raises ArgumentError with standardized JSON from NilCheck before must: runs', :aggregate_failures do
      error = begin
        required_must_actor.call
      rescue ServiceActor::ArgumentError => e
        e
      end

      expect(error).to be_a(ServiceActor::ArgumentError)

      parsed = JSON.parse(error.message, symbolize_names: true)
      expect(parsed).to eq(error: 'required', detail: 'email')
    end
  end

  describe 'provided inputs still validate normally' do
    it 'raises on wrong type with standardized JSON', :aggregate_failures do
      error = begin
        required_input_actor.call(name: 123)
      rescue ServiceActor::ArgumentError => e
        e
      end

      expect(error).to be_a(ServiceActor::ArgumentError)

      parsed = JSON.parse(error.message, symbolize_names: true)
      expect(parsed).to eq(error: 'invalid_format', detail: 'name')
    end

    it 'raises on nil when not allowed with standardized JSON', :aggregate_failures do
      error = begin
        required_input_actor.call(name: nil)
      rescue ServiceActor::ArgumentError => e
        e
      end

      expect(error).to be_a(ServiceActor::ArgumentError)

      parsed = JSON.parse(error.message, symbolize_names: true)
      expect(parsed).to eq(error: 'required', detail: 'name')
    end

    it 'succeeds with correct input', :aggregate_failures do
      result = required_input_actor.call(name: 'Alice')

      expect(result[:name]).to eq('Alice')
    end

    it 'raises on failed must: check with provided value', :aggregate_failures do
      expect { required_must_actor.call(email: '') }.to raise_error(ServiceActor::ArgumentError)
    end
  end
end
