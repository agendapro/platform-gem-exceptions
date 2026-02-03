# frozen_string_literal: true

require_relative 'lib/platform/exceptions/version'

Gem::Specification.new do |spec|
  spec.name = 'platform-gem-exceptions'
  spec.version = Platform::Exceptions::VERSION
  spec.authors = ['Rodrigo Vilina']
  spec.email = ['rodrigovilina@agendapro.com']
  spec.summary = 'state of the art exception handling for controller actions'
  spec.homepage = 'https://github.com/agendapro/platform-gem-exceptions'
  spec.required_ruby_version = '>= 3.2.0'
  spec.files = Dir['lib/**/*', 'CHANGELOG.md', 'README.md']
  spec.executables = []

  spec.metadata['homepage_uri']  = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.add_dependency 'activesupport'
  spec.add_dependency 'service_actor'
end
