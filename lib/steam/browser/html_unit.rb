require 'rubygems'
require 'core_ext/ruby/kernel/silence_warnings'

module Steam
  module Browser
    class HtmlUnit
      autoload :Connection, 'steam/browser/html_unit/connection'

      include Locators::HtmlUnit
      
      attr_accessor :client, :page, :connection, :cache, :response

      Java.import 'com.gargoylesoftware.htmlunit.WebClient'
      Java.import 'com.gargoylesoftware.htmlunit.FailingHttpStatusCodeException'

      class << self
        def build_client(connection, options = {})
          options = { :css => true, :javascript => true }.merge(options)
          connection = Connection.new(connection)

          client = Java::WebClient.new
          client.setCssEnabled(options[:css])
          client.setJavaScriptEnabled(options[:javascript])
          client.setPrintContentOnFailingStatusCode(false)
          client.setThrowExceptionOnFailingStatusCode(false)
          # client.setHTMLParserListener(nil); # doesn't work
          client.setWebConnection(Rjb::bind(connection, 'com.gargoylesoftware.htmlunit.WebConnection'))
          client
        end
      end

      def initialize(connection, options = {})
        @client = self.class.build_client(connection, options)
      end

      def call(env)
        request = Rack::Request.new(env)
        @page = client.getPage(request.url)
        respond
      end

      protected

        def respond
          @dom = nil
          status = @page.getWebResponse.getStatusCode
          headers = @page.getWebResponse.getResponseHeaders.toArray.inject({}) do |headers, pair|
            headers[pair.name] = pair.value
            headers
          end
          @response = Rack::Response.new(@page.asXml, status, headers)
          @response.to_a
        end
    end
  end
end
