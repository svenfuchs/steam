require 'rubygems'
require 'rjb'

module Steam
  module Browser
    class HtmlUnit
      autoload :Java,           'steam/browser/html_unit/java'
      autoload :MockConnection, 'steam/browser/html_unit/mock_connection'
      autoload :WebClient,      'steam/browser/html_unit/web_client'

      attr_accessor :gui, :http, :page, :connection

      def initialize(http = nil)
        @http = http || Steam::Http::RestClient.new

        @gui = WebClient.new
      end

      [:get, :post, :put, :delete, :head].each do |method|
        define_method(method) { |*args| process(method, *args) }
      end

      protected

        def process(method, request)
          @page = nil
          response = http.send(method, request)
          if response.html?
            @page = gui.process_html(request, response) 
            response.body = @page.asXml
          end
          response
        end
    end
  end
end