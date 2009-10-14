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
          @@lock.synchronize do
            # FIXME preserve original scheme, host + port
            url = request.getUrl.toString.dup
            method = request.getHttpMethod.toString.dup
            env = Request.env_for(url, :method => method)

            status, headers, response = connection.call(env)
            response.body.close if response.body.respond_to?(:close)

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

      # class Connection
      #   # @@lock = Mutex.new
      #
      #   attr_reader :connection
      #
      #   def initialize(connection)
      #     @connection = connection
      #     # @lock = Mutex.new
      #   end
      #
      #   def getResponse(request)
      #     # @lock.synchronize do
      #       method = request.getHttpMethod.toString.dup
      #       url = request.getUrl.toString.dup
      #       r = Request.new(method, url) # headers
      #       response = connection.call(r.env).last
      #
      #       # set_response(url, request, response)
      #       p response.content_type
      #       web_response = WebResponse.new(r, response)
      #       p web_response.getContentType
      #       Rjb::bind(web_response, 'com.gargoylesoftware.htmlunit.WebResponse')
      #     # end
      #   rescue Exception => e
      #     puts e.message
      #     e.backtrace.each { |line| puts line }
      #   end
      #
      #   def set_response(url, request, response)
      #     Java.import('com.gargoylesoftware.htmlunit.MockWebConnection')
      #     mock = Java::MockWebConnection.new
      #
      #     body    = response.body.join
      #     status  = response.status
      #     message = Rack::Utils::HTTP_STATUS_CODES[status.to_i]
      #     charset = 'utf-8' # FIXME
      #     headers = response.header.map { |key, value| Java::NameValuePair.new(key, value) }
      #     headers = Java::Arrays.asList(headers)
      #     content_type = response.content_type
      #
      #     mock.setResponse(Java::Url.new(url), body, status, message, content_type, charset, headers)
      #
      #     p mock.getResponse(request).getContentType
      #     p mock.getResponse(request).getContentType
      #
      #   end
      #
      #   # def method_missing(method, *args)
      #   #   puts "Method missing in WebResponse: #{method} #{args.map{ |a| a.inspect }.join(', ')}"
      #   # end
      # end

    end
  end
end