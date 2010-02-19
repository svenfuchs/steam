$: << File.expand_path("../../../lib", __FILE__)

require 'steam'

include Steam

@app = Connection::Mock.new
root = File.expand_path("../../fixtures/public", __FILE__)
static = Connection::Static.new(:root => root, :urls => %w(/ /javascripts /stylesheets))
connection = Rack::Cascade.new([static, @app])

browser = Browser::HtmlUnit::Drb.new(connection)

browser.daemonize

browser.request('/index.html')
p browser.response.status

# @browser = Browser::HtmlUnit.new(connection)