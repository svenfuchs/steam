# For internal use in Browser::HtmlUnit to hook into HtmlUnit's request process.
# Does not support the Rack interface because HtmlUnit doesn't.

require 'thread'
require 'rack/utils'

module Steam
  module Browser
    class HtmlUnit
      class Connection
        @@lock = Mutex.new

        Java.import('com.gargoylesoftware.htmlunit.MockWebConnection')
        # Java.import('java.lang.String')
        # Java.import('com.gargoylesoftware.htmlunit.WebRequestSettings')
        # Java.import('com.gargoylesoftware.htmlunit.WebResponseData')
        # Java.import('com.gargoylesoftware.htmlunit.WebResponseImpl')

        attr_reader :connection, :java

        def initialize(connection)
          @connection = connection
          @java = Java::MockWebConnection.new
        end

        def getResponse(request)
          @@lock.synchronize do
            # puts 'locked: ' + request.getUrl.toString
            # puts "requested: " + request.getUrl.toString

            # FIXME preserve original scheme, host + port
            url = request.getUrl.toString.dup
            method = request.getHttpMethod.toString.dup
            env = Request.env_for(url, :method => method)

            status, headers, response = connection.call(env)
            response.body.close if response.body.respond_to?(:close)

            # settings = Java::WebRequestSettings.new(request.getUrl) # method etc
            # 
            # body    = response.body.join
            # status  = response.status
            # message = Rack::Utils::HTTP_STATUS_CODES[status.to_i]
            # headers = response.header.map { |key, value| Java::NameValuePair.new(key, value) }
            # headers = Java::Arrays.asList(headers)
            # content_type = response.content_type
            # 
            # signature = '[B;int;java.lang.String;java.util.List;'
            # signature = 'java.io.InputStream;int;java.lang.String;java.util.List;'
            # response_data = Java::WebResponseData.new_with_sig(signature, body, status, message, headers)
            # Java::WebResponseImpl.new(response.body.join, request.getUrl)
            
            set_response(request.getUrl, response)
            java.getResponse(request)
          end
        rescue Exception => e
          puts "#{e.class.name}: #{e.message}"
          e.backtrace.each { |line| puts line }
          # exit # FIXME
        ensure
          # @@lock.unlock
          # puts 'unlocked: ' + request.getUrl.toString
        end

        def set_response(url, response)
          body    = response.body.join
          status  = response.status
          message = Rack::Utils::HTTP_STATUS_CODES[status.to_i]
          charset = 'utf-8' # FIXME
          headers = response.header.map { |key, value| Java::NameValuePair.new(key, value) }
          headers = Java::Arrays.asList(headers)
          content_type = response.content_type

          java.setResponse(url, body, status, message, content_type, charset, headers)
        end
      end
    end
  end
end