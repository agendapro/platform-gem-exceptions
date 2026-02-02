# frozen_string_literal: true

RSpec.describe Platform::Core do
  it 'has a version number' do
    expect(Platform::Core::VERSION).not_to be nil
  end
end
