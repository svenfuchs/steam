require 'rubygems'
require 'rjb'

class_path = Dir[File.expand_path(File.dirname(__FILE__) + '/../../lib/htmlunit') + '/*.jar'].join(':')

Rjb::load(class_path)

Url = Rjb::import('java.net.URL')
WebClient = Rjb::import('com.gargoylesoftware.htmlunit.WebClient')
HtmlUnitMockWebConnection = Rjb::import('com.gargoylesoftware.htmlunit.MockWebConnection')

class MockConnection
  attr_reader :connection

  def initialize
    @connection = HtmlUnitMockWebConnection.new
  end

  def method_missing(method, *args)
    p [method, args.first.toString]
    @connection.send(method, *args)
  end
end

connection = MockConnection.new
# connection = HtmlUnitMockWebConnection.new

content = '<html><head><script src="/javascripts/foo.js" type="text/javascript"></script></head><body></body></html>'
url = Url.new('http://localhost:3000/foo')
connection.setResponse(url, content, 'text/html')

content = 'document.title = "FOO";'
url = Url.new('http://localhost:3000/javascripts/foo.js')
connection.setResponse(url, content, 'application/javascript')

client = WebClient.new
client.setCssEnabled(true)
client.setJavaScriptEnabled(true)
client.setWebConnection(Rjb::bind(connection, 'com.gargoylesoftware.htmlunit.WebConnection'))
# client.setWebConnection(connection)
page = client.getPage('http://localhost:3000/foo')
# puts page.asXml
