# frozen_string_literal: true
$:.push File.expand_path('../lib', __FILE__)

require 'sail/version'

Gem::Specification.new do |s|
  s.name        = 'sail'
  s.version     = Sail::VERSION
  s.authors     = ['Vinicius Stock']
  s.email       = ['vinicius.stock@outlook.com']
  s.homepage    = 'https://github.com/vinistock/sail'
  s.summary     = 'Sail is a Rails engine for data visualization.'
  s.description = 'Sails is a Rails engine for data visualization.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '~> 5.1.4'
  s.add_dependency 'sass-rails', '~> 5.0.6'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec', '~> 3.6'
  s.add_development_dependency 'simplecov', '~> 0.14'
  s.add_development_dependency 'codeclimate-test-reporter', '~> 1.0'
  s.add_development_dependency 'byebug', '~> 9.0'
  s.add_development_dependency 'bundler', '~> 1.15'
end
