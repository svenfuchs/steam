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

        attr_reader :connection, :java

        def initialize(connection)
          @connection = connection
          @java = Java::MockWebConnection.new
        end

        def getResponse(request)
          # @@lock.lock
          # puts 'locked: ' + request.getUrl.toString
          # p "requested: " + request.getUrl.toString

          # FIXME preserve original scheme, host + port
          env = Request.env_for(request.getUrl.toString, :method => request.getHttpMethod.toString)
          status, headers, response = connection.call(env)
          set_response(request.getUrl, response)
          java.getResponse(request)
        rescue Exception => e
          puts "#{e.class.name}: #{e.message}"
          e.backtrace.each { |line| puts line }
          exit # FIXME
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