# frozen_string_literal: true

require_relative 'lib/platform/core/version'

Gem::Specification.new do |spec|
  spec.name = 'platform-core'
  spec.version = Platform::Core::VERSION
  spec.authors = ['Rodrigo Vilina']
  spec.email = ['rodrigovilina@agendapro.com']
  spec.summary = 'core components used by agendapro plt'
  spec.homepage = 'https://github.com/agendapro/platform-core'
  spec.required_ruby_version = '>= 3.2.0'
  spec.files = ['CHANGELOG.md', 'README.md']
  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore .rspec spec/ .github/ .rubocop.yml])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport'
  spec.add_dependency 'service_actor'
end
