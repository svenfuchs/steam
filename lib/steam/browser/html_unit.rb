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
      autoload :Drb,         'steam/browser/html_unit/drb'
      autoload :Forker,      'steam/browser/html_unit/forker'
      autoload :Handler,     'steam/browser/html_unit/handler'
      autoload :Matchers,    'steam/browser/html_unit/matchers'
      autoload :Page,        'steam/browser/html_unit/page'
      autoload :WebResponse, 'steam/browser/html_unit/web_response'

      include Actions

      attr_accessor :client, :page, :response

      def initialize(*args)
        @client = Client.new(*args)
      end

      def connection
        client.connection
      end

      def close
        @client.closeAllWindows
      end

      def request
        @request ||= Request.new
      end

      def get(url)
        perform(:get, url)
      end
      alias :visit :get

      def perform(method, uri)
        respond_to do
          request.update(:method => method, :uri => uri)
          client.get(request)
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

      def set_handler(type, &block) # TODO use delegate
        @client.set_handler(type, &block)
      end

      def remove_handler(type)
        @client.remove_handler(type)
      end

      def get_cookie(name)
        @client.get_cookie(name)
      end

      def add_cookie(name, value)
        @client.add_cookie(name, value)
      end

      def clear_cookies
        @client.clear_cookies
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
