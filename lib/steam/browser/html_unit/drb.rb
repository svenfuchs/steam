require 'drb'

module Steam
  module Browser
    class HtmlUnit
      class Drb
        autoload :Client,  'steam/browser/html_unit/drb/client'
        autoload :Service, 'steam/browser/html_unit/drb/service'

        def initialize
          DRb.start_service
          @browser = DRbObject.new(nil, Steam.config[:drb_uri])
        end
        
        def daemonize(connection = nil, options = {})
          Forker.new { start(connection, options) }
          sleep(1) # FIXME
        end
        
        def start(connection = nil, options = {})
          uri = Steam.config[:drb_uri]
          DRb.start_service(uri, HtmlUnit.new(connection, options))
          puts "Browser ready and listening at #{uri}"
          DRb.thread.join
        end

        def method_missing(method, *args, &block)
          @browser.send(method, *args, &block)
        end
      end
    end
  end
end