require 'drb'

module Steam
  module Browser
    class HtmlUnit
      class Drb
        autoload :Client,  'steam/browser/html_unit/drb/client'
        autoload :Service, 'steam/browser/html_unit/drb/service'

        def initialize(connection, options = {})
          DRb.start_service
          @drb = DRbObject.new(nil, Steam.config[:drb_uri])
          @connection = connection
          @options = options
        end
        
        def daemonize
          Forker.new(@options) { start }
          sleep(1) # FIXME
        end
        
        def start
          uri = Steam.config[:drb_uri]
          DRb.start_service(uri, HtmlUnit.new(@connection, @options)) rescue Errno::EADDRINUSE
          puts "HtmlUnit ready and listening at #{uri}"
          DRb.thread.join
        end

        def method_missing(method, *args, &block)
          @drb.send(method, *args, &block)
        end
      end
    end
  end
end