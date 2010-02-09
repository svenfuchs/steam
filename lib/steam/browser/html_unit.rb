require 'locator'

module Steam
  module Browser
    class HtmlUnit
      autoload :Actions,     'steam/browser/html_unit/actions'
      autoload :Client,      'steam/browser/html_unit/client'
      autoload :Connection,  'steam/browser/html_unit/connection'
      autoload :Matchers,    'steam/browser/html_unit/matchers'
      autoload :Page,        'steam/browser/html_unit/page'
      autoload :WebResponse, 'steam/browser/html_unit/web_response'

      include Actions # Matchers

      attr_accessor :client, :page, :connection, :request, :response

      def initialize(*args)
        @client = Client.new(*args)
      end

      def request(url)
        call Request.env_for(url)
      end
      alias :visit :request

      def call(env)
        @request = Rack::Request.new(env)
        @page = client.request(@request.url)
        respond!
      end

      def execute(javascript)
        @page.executeJavaScript(javascript) # FIXME doesn't respond?
      end

      def current_url
        page.getWebResponse.getRequestSettings.getUrl.toString
      end
      
      def html
        response.body.join
      end

      def locate(*args, &block)
        return args.first if args.first.respond_to?(:_classname)

        # FIXME why not just use self.html?
        element = Locator.locate(@page.as_xml, *args, &block) 
        element || raise(ElementNotFound.new(*args))
        # FIXME remove silence_warnings
        # FIXME raise something meaningful
        silence_warnings { page.getFirstByXPath(element.xpath) }
      end
      
      def within(*args, &block)
        Locator.within(html, *args, &block)
      end

      protected

        def action
          @page = yield || raise('Action did not return a dom.gargoylesoftware.htmlunit.html.HtmlPage.')
          respond!
        end

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
        end
    end
  end
end
