# Browser implementation using HtmlUnit. Steam::Session delegates here, so this
# interface is available in your Cucumber environment. Also see HtmlUnit::Actions
# which is included here.

require 'locator'
require 'core_ext/ruby/kernel/silence_warnings'

module Steam
  module Browser
    class HtmlUnit
      autoload :Actions,     'steam/browser/html_unit/actions'
      autoload :Client,      'steam/browser/html_unit/client'
      autoload :Drb,         'steam/browser/html_unit/drb'
      autoload :Forker,      'steam/browser/html_unit/forker'
      autoload :Connection,  'steam/browser/html_unit/connection'
      autoload :Matchers,    'steam/browser/html_unit/matchers'
      autoload :Page,        'steam/browser/html_unit/page'
      autoload :WebResponse, 'steam/browser/html_unit/web_response'

      include Actions

      attr_accessor :client, :page, :request, :response

      def initialize(*args)
        @client = Client.new(*args)
      end

      def connection
        client.connection
      end

      def close
        @client.closeAllWindows
      end

      def request(url)
        call Request.env_for(url)
      end
      alias :visit :request

      def call(env)
        respond_to do
          @request = Rack::Request.new(env)
          client.request(@request.url)
        end.to_a
      end

      def execute(javascript)
        page.execute(javascript) # FIXME does execute return a page so we need to respond?
      end

      def locate(*args, &block)
        Locator.locate(dom, *args, &block) || raise(ElementNotFound.new(*args))
      end

      def locate_in_browser(*args, &block)
        if args.first.respond_to?(:_classname)     # native HtmlUnit element
          args.first
        elsif args.first.respond_to?(:xpath)       # Locator element
          silence_warnings { page.getFirstByXPath(args.first.xpath) }
        else
          locate_in_browser(locate(*args, &block)) # something else
        end
      end

      def within(*args, &block)
        Locator.within(response.body, *args, &block)
      end

      protected

        def respond_to
          result = yield || raise('Block did not yield a dom.gargoylesoftware.htmlunit.html.HtmlPage.')
          @page = Page.new(result)
          client.wait_for_javascript(Steam.config[:html_unit][:js_timeout])
          @response = Response.new(*page.to_a)
        end

        def dom
          case Locator::Dom.adapter.name # yuck
          when /Nokogiri/
            response.body
          when /Htmlunit/
            @page.page
          else
            raise 'incompatible Locator::Dom adapter'
          end
        end
    end
  end
end
