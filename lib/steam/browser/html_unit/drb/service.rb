require 'drb'

module Steam
  module Browser
    class HtmlUnit
      module Drb
        module Service
          class << self
            def uri
              'druby://127.0.0.1:9000'
            end

            def daemonize(connection = nil, options = {})
              Forker.new { start(connection, options) }
            end
            
            def start(connection = nil, options = {})
              DRb.start_service(uri, HtmlUnit::Client.new(connection, options))
              puts "Browser ready and listening at #{uri}"
              DRb.thread.join
            end
          end
        end
      end
    end
  end
end