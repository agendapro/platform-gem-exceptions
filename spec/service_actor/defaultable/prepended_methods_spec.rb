# frozen_string_literal: true

RSpec.describe 'ServiceActor::Defaultable override' do
  describe 'PrependedMethods#raise_error_with' do
    it 'returns nil instead of raising' do
      obj = Object.new
      obj.extend(ServiceActor::Defaultable::PrependedMethods)

      expect(obj.send(:raise_error_with, 'some error message')).to be_nil
    end
  end
end
