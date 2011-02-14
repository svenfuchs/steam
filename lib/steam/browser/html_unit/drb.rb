require 'drb'

module Steam
  module Browser
    class HtmlUnit
      class Drb
        attr_reader :process, :connection, :options

        def initialize(connection, options = {})
          @connection, @options = connection, options
          @process = Steam::Process.new

          process.kill if options[:restart] && process.running?
          options[:daemon] ? daemonize : start unless process.running?
        end

        def object
          @object ||= DRbObject.new(nil, Steam.config[:drb_uri])
        end

        def daemonize
          options[:keep_alive] = true unless options.key?(:keep_alive)
          process.fork(options) { start }
          sleep(1) # FIXME
        end

        def start
          uri = Steam.config[:drb_uri]
          DRb.start_service(uri, HtmlUnit.new(connection, options))
          puts "HtmlUnit ready and listening at #{uri} [#{::Process.pid}]"
          DRb.thread.join
        end

        def restart
          process.kill if process.running?
          daemonize
        end

        def method_missing(method, *args, &block)
          object.send(method, *args, &block)
        end
      end
    end
  end
end