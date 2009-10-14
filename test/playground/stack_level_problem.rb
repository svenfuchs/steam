$: << File.expand_path(File.dirname(__FILE__) + "/../../lib")
require 'steam'
require 'steam/browser/html_unit/client'
include Steam

class WebResponse
  Java.import 'java.net.Url'
  Java.import 'java.io.ByteArrayInputStream'
  Java.import 'com.gargoylesoftware.htmlunit.WebRequestSettings'

  attr_reader :request, :response

  def initialize(request, response)
    @request = request
    @response = response
  end

  def getRequestSettings
    Java::WebRequestSettings.new(Java::Url.new('http://localhost:3000/'))
  end
  
  def getResponseHeaders
    Java::Arrays.asList([])
  end

  def getResponseHeaderValue(name)
    ''
  end

  def getStatusCode
    200
  end

  def getStatusMessage
    'OK'
  end

  def getContentType
    response.content_type.split(';').first
  end

  def getContentCharset
    'utf-8'
  end

  def getContentCharsetOrNull
    'utf-8'
  end

  def getContentAsString
    @body ||= response.body.join
  end

  def getContentAsStream
    bytes = getContentAsString.unpack('C*')
    Java::ByteArrayInputStream.new_with_sig('[B', bytes)
  end
end

class Connection
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
  
  @@responses = {
    'http://localhost:3000/' => Rack::Response.new(page, 200),
    'http://localhost:3000/ajax/1' => Rack::Response.new('post ajax call!', 200, 'Content-Type' => 'application/javascript')
  }
  
  @@track = []
  
  def getResponse(request)
    url = request.getUrl.toString.dup
    method = request.getHttpMethod.toString.dup
    request = Request.new(method, url) # headers
    response = @@responses[url]
    Rjb::bind(WebResponse.new(request, response), 'com.gargoylesoftware.htmlunit.WebResponse')
  rescue Exception => e
    puts e.message
    e.backtrace.each { |line| puts line }
  end
end


client = Java::WebClient.new(Java::BrowserVersion.FIREFOX_3)
client.setCssEnabled(true)
client.setJavaScriptEnabled(true)

connection = Connection.new
client.setWebConnection(Rjb::bind(connection, 'com.gargoylesoftware.htmlunit.WebConnection'))

page = client.getPage('http://localhost:3000/')
puts page.asXml
puts page.getTitleText
