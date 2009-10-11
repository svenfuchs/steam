require 'uri'
require 'patron'

module Steam
  module Connection
    class Patron < Patron::Session
      def call(env)
        request = Rack::Request.new(env)
        @base_url = base_url(request)
        method  = request.request_method.downcase.to_sym
        headers = {}              # FIXME ... request.header, cookies?
        options = { :data => '' } # FIXME ... body
        response = self.request(method, request.path, headers, options)
        Rack::Response.new(response.body, response.status, response.headers).to_a
      end

      def base_url(request = nil)
        @base_url ||= "#{request.scheme}://#{request.host}" + (request.port ? ":#{request.port}" : '')
      end
    end
  end
end