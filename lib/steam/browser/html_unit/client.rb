require 'drb'
require 'steam/java'

module Steam
  module Browser
    class HtmlUnit
      class Client
        class SilencingListener
          def notify(message, origin); end
        end

        Java.import 'com.gargoylesoftware.htmlunit.WebClient'
        Java.import 'com.gargoylesoftware.htmlunit.BrowserVersion'
        Java.import 'com.gargoylesoftware.htmlunit.NicelyResynchronizingAjaxController'
        # Java.import 'com.gargoylesoftware.htmlunit.FailingHttpStatusCodeException'

        def initialize(connection = nil, options = {})
          options = { :css => true, :javascript => true }.merge(options)

          @java = Java::WebClient.new(Java::BrowserVersion.FIREFOX_3)
          @java.setCssEnabled(options[:css])
          @java.setJavaScriptEnabled(options[:javascript])
          # @java.setPrintContentOnFailingStatusCode(false)
          # @java.setThrowExceptionOnFailingStatusCode(false)

          listener = Rjb::bind(SilencingListener.new, 'com.gargoylesoftware.htmlunit.IncorrectnessListener')
          @java.setIncorrectnessListener(listener)

          controller = Java::NicelyResynchronizingAjaxController.new
          @java.setAjaxController(controller)

          if connection
            connection = Rjb::bind(Connection.new(connection), 'com.gargoylesoftware.htmlunit.WebConnection')
            @java.setWebConnection(connection)
          end
        end

        def request(*args)
          @java.getPage(*args) # TODO use WebRequestSettings
        end

        def method_missing(method, *args)
          @java.send(method, *args)
        end
      end
    end
  end
end