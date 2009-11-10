module Steam
  module Connection
    class Mock
      class << self
        def default_content_types
          {
            :html       => 'text/html',
            :xml        => 'application/xml',
            :javascript => 'application/javascript',
            :stylesheet => 'text/css'
          }
        end
      end

      def initialize
        @responses = {}
      end

      def call(env)
        request = Rack::Request.new(env)
        response(request.request_method, request.url).to_a
      end

      def response(method, url)
        responses(method)[url] || Rack::Response.new('', 404)
      end

      def mock(method, url, response, headers = {})
        responses(method)[url] = case response
          when Rack::Response
            response
          when Array
            Rack::Response.new(*response)
          when String
            Rack::Response.new(response, 200, headers)
          end
      end

      protected

        def responses(method)
          @responses[method.to_s.upcase] ||= {}
        end

        def content_type(type)
          self.class.default_content_types[type]
        end
    end
  end
end
