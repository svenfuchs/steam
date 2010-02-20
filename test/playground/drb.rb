$: << File.expand_path("../../../lib", __FILE__)

require 'steam'

include Steam

root = File.expand_path("../../fixtures/public", __FILE__)
connection = Connection::Static.new(:root => root, :urls => %w(/ /javascripts /stylesheets))


browser = Steam::Browser.create(:html_unit, connection, :daemon => true)
browser.request('/index.html')
puts browser.response.status

# @browser = Browser::HtmlUnit.new(connection)