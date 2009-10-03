require 'rest_client'
require 'steam/response'

module Steam
  module Connection
    class RestClient
      def get(request)
        process(:get, request.url, request.headers)
      end

      def post(request)
        process(:post, request.url, request.params, request.headers)
      end

      def put(request)
        process(:put, request.url, request.params, request.headers)
      end

      def delete(request)
        process(:delete, request.url, request.headers)
      end

      def head(request)
        process(:head, request.url, request.headers)
      end

      def process(method, *args)
        response = ::RestClient.send(method, *args)
        Rack::Response.new(response.to_s, response.code, response.headers, response.cookies)
      rescue ::RestClient::ExceptionWithResponse => e
        response = e.response
        Rack::Response.new(response.body, response.code) # headers?
      end
    end
  end
end