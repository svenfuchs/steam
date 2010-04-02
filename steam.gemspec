# encoding: utf-8

require File.expand_path('../lib/steam/version', __FILE__)

Gem::Specification.new do |s|
  s.name         = 'steam'
  s.version      = Steam::VERSION
  s.authors      = ['Sven Fuchs']
  s.email        = 'svenfuchs@artweb-design.de'
  s.homepage     = 'http://github.com/svenfuchs/steam'
  s.summary      = 'Headless integration testing w/ HtmlUnit: enables testing JavaScript-driven web sites'
  s.description  = 'Steam is a headless integration testing tool driving HtmlUnit to enable testing JavaScript-driven web sites.'
  s.files        = Dir.glob('lib/**/*') + %w(MIT-LICENSE README.textile)

  s.add_runtime_dependency 'rjb',     '>= 1.2.0'
  s.add_runtime_dependency 'locator', '>= 0.0.6'

  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.rubyforge_project = '[none]'
  s.required_rubygems_version = '>= 1.3.6'
end
