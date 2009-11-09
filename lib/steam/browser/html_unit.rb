module Steam
  module Browser
    class HtmlUnit
      autoload :Actions,     'steam/browser/html_unit/actions'
      autoload :Drb,         'steam/browser/html_unit/drb'
      autoload :Page,        'steam/browser/html_unit/page'
      autoload :Client,      'steam/browser/html_unit/client'
      autoload :Connection,  'steam/browser/html_unit/connection'
      autoload :WebResponse, 'steam/browser/html_unit/web_response'

      include Actions
      include Locators
      include Matchers::HtmlUnit

      attr_accessor :client, :page, :connection, :request, :response

      def initialize(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        connection = args.pop

        @client = options[:drb] ? Drb::Client.new : Client.new(connection, options)
      end

      def html
        response.body.join
      end

      def request(url)
        call Request.env_for(url)
      end
      alias :visit :request

      def call(env)
        @dom = nil
        @request = Rack::Request.new(env)
        @page = client.request(@request.url)
        respond!
      end

      def execute(javascript)
        @page.executeJavaScript(javascript)
      end

      def current_url
        page.getWebResponse.getRequestSettings.getUrl.toString
      end

      protected

        def respond!
          @client.waitForBackgroundJavaScript(5000) # FIXME should probably use some block syntax

          body    = @page.asXml
          status  = @page.getWebResponse.getStatusCode
          headers = @page.getWebResponse.getResponseHeaders.toArray.inject({}) do |headers, pair|
            headers[pair.name] = pair.value
            headers
          end
          @response = Rack::Response.new(body, status, headers)
          @response.to_a
        # rescue Exception => e
        #   puts e.message
        #   e.backtrace.each { |line| puts line }
        #   nil
        end
    end
  end
end
