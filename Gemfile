source('https://rubygems.org')

gemspec

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)

gem "rubocop-rake", "~> 0.6.0"

gem "rubocop-rspec", "~> 2.4"
