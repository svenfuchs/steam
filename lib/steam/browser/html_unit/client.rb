module Steam
  module Browser
    class HtmlUnit
      class Client
        class SilencingListener
          def notify(message, origin); end
        end
        
        Java.import 'com.gargoylesoftware.htmlunit.WebClient'
        Java.import('com.gargoylesoftware.htmlunit.BrowserVersion')
        
        attr_reader :client

        def initialize(connection = nil, options = {})
          options = { :css => true, :javascript => true }.merge(options)

          @client = Java::WebClient.new(Java::BrowserVersion.FIREFOX_3)
          @client.setCssEnabled(options[:css])
          @client.setJavaScriptEnabled(options[:javascript])
          @client.setPrintContentOnFailingStatusCode(false)
          @client.setThrowExceptionOnFailingStatusCode(false)

          listener = Rjb::bind(SilencingListener.new, 'com.gargoylesoftware.htmlunit.IncorrectnessListener')
          @client.setIncorrectnessListener(listener)

          if connection
            Rjb::bind(Connection.new(connection), 'com.gargoylesoftware.htmlunit.WebConnection')
            @client.setWebConnection(connection)
          end
        end
        
        def request(*args)
          page = Page.new(@client.getPage(*args))
          [page, Rack::Response.new(page.body, page.status, page.headers)]
        end
      end
    end
  end
end