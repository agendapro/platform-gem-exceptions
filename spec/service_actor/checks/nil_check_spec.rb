# frozen_string_literal: true

RSpec.describe 'ServiceActor::Checks overrides' do
  describe 'NilCheck::DEFAULT_MESSAGE' do
    it 'returns ErrorMessage JSON with required' do
      message = ServiceActor::Checks::NilCheck::DEFAULT_MESSAGE.call(input_key: :name)
      result = JSON.parse(message, symbolize_names: true)

      expect(result).to eq(error: 'required', detail: 'name')
    end
  end
end
