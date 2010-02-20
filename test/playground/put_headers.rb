$: << File.expand_path(File.dirname(__FILE__) + "/../../lib")
require 'test/unit'
require 'steam'
include Steam

Java.import 'com.gargoylesoftware.htmlunit.WebClient'
Java.import 'com.gargoylesoftware.htmlunit.BrowserVersion'
Java.import 'com.gargoylesoftware.htmlunit.FailingHttpStatusCodeException'
Java.import 'com.gargoylesoftware.htmlunit.NicelyResynchronizingAjaxController'

SILENCE = true

class TestConnection < Browser::HtmlUnit::Connection
  attr_reader :url, :method, :headers

  def getResponse(request)
    @url = request.getUrl.toString
    # $method = request.getMethod.toString
    @headers = Hash[*request.getAdditionalHeaders.entrySet.toArray.to_a.map do |a|
      [a.getKey.toString, a.getValue.toString]
    end.flatten]
    super
  end
end

class TestHtmlUnit < Test::Unit::TestCase
  def setup
    @client = Java::WebClient.new(Java::BrowserVersion.FIREFOX_3)
    @client.setCssEnabled(true)
    @client.setJavaScriptEnabled(true)
    # client.setAjaxController(Java::NicelyResynchronizingAjaxController.new)

    @mock = Connection::Mock.new
    @connection = TestConnection.new(@mock)
    @client.setWebConnection(Rjb::bind(@connection, 'com.gargoylesoftware.htmlunit.WebConnection'))
  end

  def _test_xml_http_request_accept_header
    page = <<-erb
      <html>
        <head>
          <script>
            document.title = 'pre ajax call';
            function ajax(url) {
              http = new XMLHttpRequest();
              http.open("GET", url, true);
              http.setRequestHeader('Accept', 'application/json')
              http.send(null);
            }
            ajax('/ajax/1');
          </script>
        </head>
      </html>
    erb

    @mock.mock :get, 'http://localhost:3000/', page
    page = @client.getPage('http://localhost:3000/')
    assert_equal 'application/json', @connection.headers['Accept']
  end

  def test_xml_http_request_delete_query_params
    page = <<-erb
      <html>
        <head>
          <script>
            document.title = 'pre ajax call';
            function ajax(url) {
              http = new XMLHttpRequest();
              http.open("DELETE", url, true);
              http.setRequestHeader('Accept', 'application/json')
              http.send(null);
            }
            ajax('/ajax/1?foo=bar');
          </script>
        </head>
      </html>
    erb

    @mock.mock :get, 'http://localhost:3000/', page
    page = @client.getPage('http://localhost:3000/')
    assert_equal 'http://localhost:3000/ajax/1?foo=bar', @connection.url
  end
end
