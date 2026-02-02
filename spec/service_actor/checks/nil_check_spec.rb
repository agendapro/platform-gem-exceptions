# frozen_string_literal: true

RSpec.describe 'ServiceActor::Checks overrides' do
  describe 'InclusionCheck::DEFAULT_MESSAGE' do
    it 'returns ErrorMessage JSON with invalid_format' do
      message = ServiceActor::Checks::InclusionCheck::DEFAULT_MESSAGE.call(input_key: :status)
      result = JSON.parse(message, symbolize_names: true)

      expect(result).to eq(error: 'invalid_format', detail: 'status')
    end
  end

  describe 'NilCheck::DEFAULT_MESSAGE' do
    it 'returns ErrorMessage JSON with required' do
      message = ServiceActor::Checks::NilCheck::DEFAULT_MESSAGE.call(input_key: :name)
      result = JSON.parse(message, symbolize_names: true)

      expect(result).to eq(error: 'required', detail: 'name')
    end
  end

  describe 'TypeCheck::DEFAULT_MESSAGE' do
    it 'returns ErrorMessage JSON with invalid_format' do
      message = ServiceActor::Checks::TypeCheck::DEFAULT_MESSAGE.call(input_key: :age)
      result = JSON.parse(message, symbolize_names: true)

      expect(result).to eq(error: 'invalid_format', detail: 'age')
    end
  end
end
