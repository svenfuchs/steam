# For internal use in Browser::HtmlUnit to hook into HtmlUnit's request process.
# Does not support the Rack interface because HtmlUnit doesn't. Not currently
# used by Steam, but potentially useful to get HtmlUnit and the app running in
# a single stack.
#
# Can be set to a com.gargoylesoftware.htmlunit.WebClient like this:
#
#   mock = Steam::Connection::Mock.new
#   mock.mock :get, 'http://localhost:3000/', 'body!'
#   connection = Steam::Browser::HtmlUnit::Connection.new(mock)
#
#   client = java::WebClient.new(Java::Com::Gargoylesoftware::Htmlunit::BrowserVersion.FIREFOX_3)
#   client.setWebConnection(Rjb::bind(connection, 'com.gargoylesoftware.htmlunit.WebConnection'))

require 'thread'
require 'rack/utils'

module Steam
  module Browser
    class HtmlUnit
      class Connection
        @@lock = Mutex.new

        Java.import 'com.gargoylesoftware.htmlunit.Version'

        include Java::Com::Gargoylesoftware::Htmlunit

        Java.import 'com.gargoylesoftware.htmlunit.MockWebConnection'
        classifier = Version.getProductVersion == '2.6' ?
          'org.apache.commons.httpclient.NameValuePair' :    # HtmlUnit 2.6
          'com.gargoylesoftware.htmlunit.util.NameValuePair' # HtmlUnit 2.7
        NameValuePair = Java.import(classifier, :NameValuePair)

        attr_reader :connection, :java

        def initialize(connection)
          @connection = connection
          @java = MockWebConnection.new
        end

        def getResponse(request_settings)
          # FIXME preserve original scheme, host + port
          method = request_settings.getHttpMethod.toString.dup
          url    = request_settings.getUrl.toString.dup

          body   = request_settings.getRequestBody
          body   = body.toString.dup if body

          params = request_settings.getRequestParameters
          params = Hash[*params.toArray.map { |e| [e.name, e.value] }.flatten]

          input  = body ? body : Rack::Utils.build_nested_query(params)
          env    = Request.new(:method => method, :url => url, :input => input).env

          status, headers, response = connection.call(env)
          response.body.close if response.body.respond_to?(:close)

          set_response(request_settings.getUrl, response)
          java.getResponse(request_settings)
        rescue Exception => e
          puts "#{e.class.name}: #{e.message}"
          e.backtrace.each { |line| puts line }
        end

        def set_response(url, response)
          body    = response.body.join
          status  = response.status
          message = Rack::Utils::HTTP_STATUS_CODES[status.to_i]
          charset = Steam.config[:charset]
          headers = response.header.map { |key, value| NameValuePair.new(key, value) }
          headers = Java::Util::Arrays.asList(headers)
          content_type = response.content_type

          java.setResponse(url, body, status, message, content_type, charset, headers)
        end
      end
    end
  end
end