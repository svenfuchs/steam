require 'rubygems'
require 'rjb'

module Steam
  module Browser
    class HtmlUnit
      class Connection
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

          # FIXME convert to ruby hashes
          # params  = request.getRequestParameters
          # headers = request.getAdditionalHeaders
          java.setResponse(request.getUrl, response.body.join, response.content_type)
          java.getResponse(request)
        rescue Exception => e
          puts "#{e.class.name}: #{e.message}"
          e.backtrace.each { |line| puts line }
          exit # FIXME
        end
      end

      attr_accessor :ui, :http, :page, :connection

      Java.import 'com.gargoylesoftware.htmlunit.WebClient'

      def initialize(http = nil, options = {})
        default_options = { :css => true, :javascript => true }
        options = default_options.merge(options)

        @connection = Connection.new(http || Steam::Connection::RestClient.new)

        @ui = Java::WebClient.new
        @ui.setCssEnabled(options[:css])
        @ui.setJavaScriptEnabled(options[:javascript])
        @ui.setWebConnection(Rjb::bind(connection, 'com.gargoylesoftware.htmlunit.WebConnection'))
      end

      def call(env)
        request = Rack::Request.new(env)
        @page = ui.getPage(request.url)                # FIXME include request headers etc
        Rack::Response.new(@page.asXml, 200, {}).to_a  # FIXME return a full response
      end
    end
  end
end