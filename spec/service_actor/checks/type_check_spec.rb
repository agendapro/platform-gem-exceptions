# frozen_string_literal: true

RSpec.describe 'ServiceActor::Checks overrides' do
  describe 'TypeCheck::DEFAULT_MESSAGE' do
    it 'returns ErrorMessage JSON with invalid_format' do
      message = ServiceActor::Checks::TypeCheck::DEFAULT_MESSAGE.call(input_key: :name)
      result = JSON.parse(message, symbolize_names: true)

      expect(result).to eq(error: 'invalid_format', detail: 'name')
    end
  end
end
