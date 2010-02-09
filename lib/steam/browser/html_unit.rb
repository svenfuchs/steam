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
        respond_to do
          @request = Rack::Request.new(env)
          client.request(@request.url)
        end.to_a
      end

      def execute(javascript)
        page.execute(javascript) # FIXME does execute return a page so we need to respond?
      end

      def locate(*args, &block)
        Locator.locate(response.body, *args, &block) || raise(ElementNotFound.new(*args))
      end

      def locate_in_browser(*args, &block)
        if args.first.respond_to?(:_classname)
          args.first
        else
          element = locate(*args, &block)
          # FIXME remove silence_warnings, raise something meaningful
          silence_warnings { page.getFirstByXPath(element.xpath) }
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
    end
  end
end
