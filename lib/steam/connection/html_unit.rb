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
        # p request.toString
        mock_response(request)
        java.getResponse(request)
      rescue Exception => e
        puts "#{e.class.name}: #{e.message}"
        e.backtrace.each { |line| puts line }
        nil # FIXME return a web response so we don't get a nullpointer exception in java
      end
      
      def mock_response(request)
        method = request.getHttpMethod.toString.downcase
        response = connection.send(method, steam_request(request))
        java.setResponse(request.getUrl, response.body.join, response.content_type)
      end

      protected
      
        def steam_request(request)
          # FIXME convert to ruby hashes
          # params  = request.getRequestParameters
          # headers = request.getAdditionalHeaders
          r = Request.new(request.getHttpMethod, request.getUrl.toString)
          r
        end
    end
  end
end