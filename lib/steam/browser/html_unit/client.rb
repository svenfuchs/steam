require 'drb'
require 'steam/java'

module Steam
  module Browser
    class HtmlUnit
      class Client
        class SilencingListener
          def notify(message, origin); end
        end
        
        include Locators::HtmlUnit

        Java.import 'com.gargoylesoftware.htmlunit.WebClient'
        Java.import 'com.gargoylesoftware.htmlunit.BrowserVersion'
        Java.import 'com.gargoylesoftware.htmlunit.FailingHttpStatusCodeException'

        attr_reader :java, :page

        def initialize(connection = nil, options = {})
          options = { :css => true, :javascript => true }.merge(options)

          @java = Java::WebClient.new(Java::BrowserVersion.FIREFOX_3)
          @java.setCssEnabled(options[:css])
          @java.setJavaScriptEnabled(options[:javascript])
          # @java.setPrintContentOnFailingStatusCode(false)
          # @java.setThrowExceptionOnFailingStatusCode(false)

          listener = Rjb::bind(SilencingListener.new, 'com.gargoylesoftware.htmlunit.IncorrectnessListener')
          @java.setIncorrectnessListener(listener)

          if connection
            connection = Rjb::bind(Connection.new(connection), 'com.gargoylesoftware.htmlunit.WebConnection')
            @java.setWebConnection(connection)
          end
        end
        
        def request(*args)
          @page = Page.new(@java.getPage(*args)) # TODO use WebRequestSettings
          Rack::Response.new(page.body, page.status, page.headers).to_a
        # rescue Exception => e
        #   puts e.message
        #   e.backtrace.each { |line| puts line }
        #   nil
        # rescue Exception => e
        #   Rack::Response.new('', 404).to_a
        end
      end
    end
  end
end