# frozen_string_literal: true
$:.push File.expand_path('../lib', __FILE__)

require 'sail/version'

Gem::Specification.new do |s|
  s.name        = 'sail'
  s.version     = Sail::VERSION
  s.authors     = ['Vinicius Stock']
  s.email       = ['vinicius.stock@outlook.com']
  s.homepage    = 'https://github.com/vinistock/sail'
  s.summary     = 'Sail will help you navigate your Rails application.'
  s.description = 'Sail brings application settings into your Rails application for controlling features.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'rails', '~> 5.2.0'
  s.add_dependency 'sass-rails', '~> 5.0.6'
  s.add_dependency 'jquery-rails', '~> 4.3.1'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails', '~> 3.8.0'
  s.add_development_dependency 'simplecov', '~> 0.16.1'
  s.add_development_dependency 'codeclimate-test-reporter', '~> 1.0'
  s.add_development_dependency 'byebug', '~> 10.0.2'
  s.add_development_dependency 'bundler', '~> 1.16.4'
  s.add_development_dependency 'database_cleaner', '~> 1.7.0'
end
