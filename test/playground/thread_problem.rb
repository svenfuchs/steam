# require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

$: << File.expand_path(File.dirname(__FILE__) + "/../../lib")
require 'steam'
include Steam

Java.import 'com.gargoylesoftware.htmlunit.WebClient'
Java.import 'com.gargoylesoftware.htmlunit.BrowserVersion'
Java.import 'com.gargoylesoftware.htmlunit.FailingHttpStatusCodeException'

page = <<-erb
  <html>
    <head>
      <script>
        document.title = 'pre ajax call';
        function some_ajax(url) {
          http = new XMLHttpRequest();
          http.open("GET", url, true);
          http.onreadystatechange = function() {
            document.title = document.title + ' ' + http.readyState
            if(http.readyState == 4) document.title = http.responseText
          }
          http.send(null);
        }
        some_ajax('/ajax/1');
        // some_ajax('/ajax/2');
      </script>
    </head>
  </html>
erb

client = Java::WebClient.new(Java::BrowserVersion.FIREFOX_3)
client.setCssEnabled(true)
client.setJavaScriptEnabled(true)

mock = Connection::Mock.new
mock.mock :get, 'http://localhost:3000/', page
mock.mock :get, 'http://localhost:3000/ajax/1', 'post ajax call 1!', 'Content-Type' => 'application/javascript'
# mock.mock :get, 'http://localhost:3000/ajax/2', 'post ajax call 2!', 'Content-Type' => 'application/javascript'

connection = Browser::HtmlUnit::Connection.new(mock)
client.setWebConnection(Rjb::bind(connection, 'com.gargoylesoftware.htmlunit.WebConnection'))

page = client.getPage('http://localhost:3000/')
puts page.asXml
puts page.getTitleText

# mock = Connection::Mock.new
# mock.mock :get, 'http://localhost:3000/', page
# mock.mock :get, 'http://localhost:3000/ajax', 'post ajax call!', 'Content-Type' => 'application/javascript'
# 
# browser = Browser::HtmlUnit.new(mock)
# # client.setWebConnection(Rjb::bind(connection, 'com.gargoylesoftware.htmlunit.WebConnection'))
# 
# response = browser.request('http://localhost:3000/').last
# puts browser.page.asXml

