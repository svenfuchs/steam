$: << File.expand_path(File.dirname(__FILE__) + "/../../../lib")
require 'drb'
require 'steam'
include Steam


mock = Connection::Mock.new
mock.mock :get, 'http://localhost:3000/', 'FOOOO'

Browser::HtmlUnit::Drb::Service.start(mock)
