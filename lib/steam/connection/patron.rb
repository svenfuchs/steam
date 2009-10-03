require 'uri'
require 'patron'
require 'steam/utils'

module Steam
  module Connection
    class Patron < Patron::Session
      def get(request)
        self.base_url = request.host_with_port
        response = super(request.path, headers)
        Rack::Response.new(response.body, response.status, response.headers) # , response.cookies
      end
  
      def post(request)
        self.base_url = request.host_with_port
        body = Utils.requestify(request.params) || ''
        response = super(request.path, body, headers)
        Rack::Response.new(response.body, response.status, response.headers) # , response.cookies
      end
    end
  end
end