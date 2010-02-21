require 'cgi'

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
        response = response(request.request_method, request.url)
        response = response.call if response.is_a?(Proc)
        response.to_a
      end

      def response(method, url)
        responses(method)[CGI::unescape(url)] || Rack::Response.new('', 404)
      end

      def mock(*args)
        headers = args.last.is_a?(Hash) ? args.pop : {}
        response, url, method = *args.reverse

        responses(method || :get)[url] = case response
          when Array
            Rack::Response.new(*response)
          when String
            Rack::Response.new(response, 200, headers)
          else
            response
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
