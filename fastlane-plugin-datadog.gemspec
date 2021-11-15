lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/datadog/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-datadog'
  spec.version       = Fastlane::Datadog::VERSION
  spec.author        = 'Datadog, Inc.'
  spec.email         = 'packages@datadoghq.com'

  spec.summary       = 'Datadog actions for iOS development'
  spec.homepage      = "https://github.com/DataDog/datadog-fastlane-plugin"
  spec.license       = "Apache-2.0"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.5'

  spec.add_development_dependency('bundler')
  spec.add_development_dependency('fastlane', '>= 2.197.0')
  spec.add_development_dependency('pry')
  spec.add_development_dependency('rake')
  spec.add_development_dependency('rspec')
  spec.add_development_dependency('rspec_junit_formatter')
  spec.add_development_dependency('rubocop', '1.12.1')
  spec.add_development_dependency('rubocop-performance')
  spec.add_development_dependency('rubocop-require_tools')
  spec.add_development_dependency('simplecov')
end
