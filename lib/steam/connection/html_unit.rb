# For internal use in Browser::HtmlUnit to hook into HtmlUnit's request process. 
# Does not support the Rack interface because HtmlUnit doesn't.

require 'rack/utils'

module Steam
  module Connection
    class HtmlUnit
      attr_reader :connection, :java

      Java.import('com.gargoylesoftware.htmlunit.MockWebConnection')

      def initialize(connection)
        @connection = connection
        @java = Java::MockWebConnection.new
      end

      def getResponse(request)
        # FIXME preserve original scheme, host + port
        env = Request.env_for(request.getUrl.toString, :method => request.getHttpMethod.toString)
        status, headers, response = connection.call(env)
        
        message = Rack::Utils::HTTP_STATUS_CODES[status.to_i]
        charset = 'utf-8' # FIXME
        headers = headers.map { |key, value| Java::NameValuePair.new(key, value) }
        headers = Java::Arrays.asList(headers)

        # FIXME convert to ruby hashes
        # params  = request.getRequestParameters
        # headers = request.getAdditionalHeaders
        java.setResponse(request.getUrl, response.body.join, status, message, response.content_type, charset, headers)
        java.getResponse(request)
      rescue Exception => e
        puts "#{e.class.name}: #{e.message}"
        e.backtrace.each { |line| puts line }
        exit # FIXME
      end
    end
  end
end