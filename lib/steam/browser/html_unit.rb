module Steam
  module Browser
    class HtmlUnit
      autoload :Page,       'steam/browser/html_unit/page'
      autoload :Client,     'steam/browser/html_unit/client'
      autoload :Connection, 'steam/browser/html_unit/connection'

      include Locators::HtmlUnit
      include Matchers::HtmlUnit
      
      attr_accessor :client, :page, :connection, :request, :response

      def initialize(connection = nil, options = {})
        @client = Client.new(connection, options)
      end
      
      def visit(url)
        call Request.env_for(url)
      end

      def call(env)
        @dom = nil
        @request = Rack::Request.new(env)
        @page, @response = client.request(@request.url)
      end
    end
  end
end
