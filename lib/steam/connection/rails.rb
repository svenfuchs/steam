module Steam
  module Connection
    class Rails
      def initialize
        @app = ActionController::Dispatcher.new
      end
      
      def call(env)
        status, headers, response = @app.call(env)
        Rack::Response.new(response_body(response), status, headers).to_a
      end
      
      def response_body(response)
        body = ''
        response.each { |part| body << part } # yuck
        body
      end
    end
  end
end
