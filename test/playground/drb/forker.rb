$: << File.expand_path(File.dirname(__FILE__) + "/../../../lib")
require 'rubygems'
require 'drb'
require 'steam'
include Steam

# Forker.new do
#   connection = Connection::Mock.new
#   connection.mock :get, 'http://localhost:3000/', 'FOOOO'
#   Browser::HtmlUnit::Drb::Service.start(connection)
# end

connection = Connection::Mock.new
connection.mock :get, 'http://localhost:3000/', 'FOOOO'
server = Browser::HtmlUnit::Drb::Service.daemonize(connection)
sleep(0.5)

browser = Browser::HtmlUnit.new(:drb => true)
status, headers, response = browser.request('http://localhost:3000/')

puts response.status
puts response.body
