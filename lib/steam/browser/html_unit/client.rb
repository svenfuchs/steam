module Steam
  module Browser
    class HtmlUnit
      class Client
        Java.import 'com.gargoylesoftware.htmlunit.WebClient'
        Java.import 'com.gargoylesoftware.htmlunit.FailingHttpStatusCodeException'
        
        attr_reader :client

        def initialize(connection, options = {})
          # FIXME! setting css to true yields a "stack-level too deep error"
          # on a random basis. looks like a threading issue. see html_unit/connection
          # for a mutex - which doesn't seem to work
          options = { :css => false, :javascript => true }.merge(options)
          connection = Connection.new(connection)

          @client = Java::WebClient.new
          @client.setCssEnabled(options[:css])
          @client.setJavaScriptEnabled(options[:javascript])
          @client.setPrintContentOnFailingStatusCode(false)
          @client.setThrowExceptionOnFailingStatusCode(false)
          # @client.setHTMLParserListener(nil); # doesn't work
          @client.setWebConnection(Rjb::bind(connection, 'com.gargoylesoftware.htmlunit.WebConnection'))
        end
        
        def request(*args)
          page = Page.new(@client.getPage(*args))
          [page, Rack::Response.new(page.body, page.status, page.headers)]
        end
      end
    end
  end
end