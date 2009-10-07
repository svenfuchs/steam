$: << File.expand_path(File.dirname(__FILE__) + "/../../../lib")

require 'rubygems'
require 'cucumber/formatter/unicode'
require 'steam'

ENV["RAILS_ENV"] ||= "test"

require File.expand_path(File.dirname(__FILE__) + '/../../fixtures/rails/config/environment.rb')
ActiveRecord::Base.establish_connection(:test)
  
World do
  root   = File.expand_path(RAILS_ROOT + '/public')
  static = Steam::Connection::Static.new(:root => root)
  rails  = Steam::Connection::Rails.new

  connection = Rack::Cascade.new([static, rails])
  browser    = Steam::Browser::HtmlUnit.new(connection)
  @session   = Steam::Session::Rails.new(browser)
end
