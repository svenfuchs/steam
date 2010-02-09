$: << File.expand_path(File.dirname(__FILE__) + "/../../../lib")
require 'rubygems'
require 'daemons'
require 'drb'
require 'steam'
include Steam


# a = Daemons.call do
#   DRb.start_service('druby://localhost:9000', Object.new)
# end

# server = Daemons.call do
#   connection = Connection::Mock.new
#   connection.mock :get, 'http://localhost:3000/', 'FOOOO'
#   Browser::HtmlUnit::Drb::Service.start(connection)
# end
# at_exit { server.stop }

connection = Connection::Mock.new
connection.mock :get, 'http://localhost:3000/', 'FOOOO'
server = Browser::HtmlUnit::Drb::Service.daemonize(connection)
sleep(0.5)

# p server.running?
browser = Browser::HtmlUnit.new(:drb => true)
status, headers, response = browser.request('http://localhost:3000/')

puts response.status
puts response.body


