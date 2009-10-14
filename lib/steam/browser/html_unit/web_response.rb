module Steam
  module Browser
    class HtmlUnit
      class WebResponse
        Java.import 'java.net.Url'
        Java.import 'java.io.ByteArrayInputStream'
        Java.import 'com.gargoylesoftware.htmlunit.WebRequestSettings'
        
        attr_reader :request, :response
        
        def initialize(request, response)
          @request = request
          @response = response
        rescue Exception => e
          puts e.message
          e.backtrace.each { |line| puts line }
        end

        def getRequestSettings
          @request_settings ||= Java::WebRequestSettings.new(Java::Url.new(request.url))
        rescue Exception => e
          puts e.message
          e.backtrace.each { |line| puts line }
        end
        
        def getResponseHeaders
          @headers ||= begin
            headers = response.header.map { |key, value| Java::NameValuePair.new(key, value) }
            Java::Arrays.asList(headers)
          end
        rescue Exception => e
          puts e.message
          e.backtrace.each { |line| puts line }
        end

        def getResponseHeaderValue(name)
          response.header[name]
        rescue Exception => e
          puts e.message
          e.backtrace.each { |line| puts line }
        end

        def getStatusCode
          @status ||= response.status
        rescue Exception => e
          puts e.message
          e.backtrace.each { |line| puts line }
        end
  
        def getStatusMessage
          @message ||= Rack::Utils::HTTP_STATUS_CODES[getStatusCode.to_i]
        rescue Exception => e
          puts e.message
          e.backtrace.each { |line| puts line }
        end

        def getContentType
          @content_type ||= begin
            content_type = response.content_type.split(';').first
            content_type = 'application/x-javascript' if content_type == 'application/javascript'
            content_type
          end
        rescue Exception => e
          puts e.message
          e.backtrace.each { |line| puts line }
        end

        def getContentCharset
          @content_charset ||= 'utf-8' # FIXME
        rescue Exception => e
          puts e.message
          e.backtrace.each { |line| puts line }
        end

        def getContentCharsetOrNull
          @content_charset_or_null ||= 'utf-8' # FIXME
        rescue Exception => e
          puts e.message
          e.backtrace.each { |line| puts line }
        end

        def getContentAsString
          @content_as_string ||= response.body.join
        rescue Exception => e
          puts e.message
          e.backtrace.each { |line| puts line }
        end

        def getContentAsStream
          @content_as_stream ||= begin
            bytes = getContentAsString.unpack('C*')
            Java::ByteArrayInputStream.new_with_sig('[B', bytes)
          end
        rescue Exception => e
          puts e.message
          e.backtrace.each { |line| puts line }
        end
        
        def method_missing(method, *args)
          puts "Method missing in WebResponse: #{method} #{args.map{ |a| a.inspect }.join(', ')}"
        end
      end
    end
  end
end