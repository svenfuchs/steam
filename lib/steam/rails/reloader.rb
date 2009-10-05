require 'thread'

module Steam
  module Rails
    class Reloader
      @@lock = Mutex.new
      cattr_accessor :default_lock

      class BodyWrapper
        def initialize(body, lock, cleanup)
          @body = body
          @lock = lock
          @cleanup = cleanup
        end

        def close
          @body.close if @body.respond_to?(:close)
        ensure
          Dispatcher.cleanup_application if @cleanup
          @lock.unlock
        end

        def method_missing(*args, &block)
          @body.send(*args, &block)
        end

        def respond_to?(symbol, include_private = false)
          symbol == :close || @body.respond_to?(symbol, include_private)
        end
      end

      def initialize(app)
        @app = app
      end

      def call(env)
        rewrite_test_env!(env)

        begin
          @@lock.lock
          Dispatcher.reload_application unless env.has_key?('rack.test.cache_classes')
          # gotta call build_middleware_stack if reloading
          status, headers, body = @app.call(env)
          [status, headers, BodyWrapper.new(body, @@lock, !env.has_key?('rack.test.cache_classes'))]
        rescue Exception
          @@lock.unlock
          raise
        end
      end

      protected

        def rewrite_test_env!(env)
          env.keys.each do |key|
            if key.include?('HTTP_RACK.TEST')
              env[key.downcase.sub(/^http_/, '')] = env.delete(key)
            end
          end
        end
    end
  end
end