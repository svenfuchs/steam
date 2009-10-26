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

content = <<-html
  <html>
    <head>
      <script>
        document.title = 'pre ajax call';
        function some_ajax(url) {
          xhr = new XMLHttpRequest();
          xhr.open("GET", url, true);
          xhr.setRequestHeader("Accept", "application/json, text/javascript, */*");
          xhr.onreadystatechange = function() {
            document.title = document.title + ' ' + xhr.readyState
            if(xhr.readyState == 4) document.title = xhr.responseText
          }
          xhr.send(null);
        }
        some_ajax('/ajax/1');
      </script>
    </head>
  </html>
html
url = Url.new('http://localhost:3000/foo')
connection.setResponse(url, content, 'text/html')

content = 'document.title = "FOO";'
url = Url.new('http://localhost:3000/ajax/1')
connection.setResponse(url, content, 'application/javascript')

client = WebClient.new
client.setCssEnabled(true)
client.setJavaScriptEnabled(true)
client.setWebConnection(Rjb::bind(connection, 'com.gargoylesoftware.htmlunit.WebConnection'))
# client.setWebConnection(connection)
page = client.getPage('http://localhost:3000/foo')
# puts page.asXml
