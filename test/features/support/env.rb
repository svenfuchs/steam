ENV["RAILS_ENV"] ||= "test"

$: << File.expand_path(File.dirname(__FILE__) + "/../../../lib")

require 'rubygems'
require 'cucumber/formatter/unicode'
require 'spork'
require 'steam'

Spork.prefork do
  require File.expand_path(File.dirname(__FILE__) + '/../../fixtures/rails/config/environment.rb')
  ActiveRecord::Base.establish_connection(:test)

  root   = File.expand_path(RAILS_ROOT + '/public')
  static = Steam::Connection::Static.new(:root => root)
  rails  = Steam::Connection::Rails.new
  
  connection = Rack::Cascade.new([static, rails])
  Steam::Browser::HtmlUnit::Drb::Service.daemonize(connection)
  sleep(0.25)

  World do
    browser = Steam::Browser::HtmlUnit.new(:drb => true)
    Steam::Session::Rails.new(browser)
  end
end

Spork.each_run do
end

