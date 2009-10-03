require 'rest_client'
require 'steam/response'

module Steam
  module Connection
    class RestClient
      def get(request)
        process(:get, request.uri.to_s, request.headers)
      end

      def post(request)
        process(:post, request.uri.to_s, request.params, request.headers)
      end

      def put(request)
        process(:put, request.uri.to_s, request.params, request.headers)
      end

      def delete(request)
        process(:delete, request.uri.to_s, request.headers)
      end

      def head(request)
        process(:head, request.uri.to_s, request.headers)
      end

      def process(method, *args)
        response = ::RestClient.send(method, *args)
        Response.new(response.to_s, response.code, response.headers, response.cookies)
      rescue ::RestClient::ExceptionWithResponse => e
        response = e.response
        Response.new(response.body, response.code) # headers?
      end
    end
  end
end