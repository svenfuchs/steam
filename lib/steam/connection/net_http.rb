# This connection proxies requests using open-uri. 
#

require 'net/http'
require 'uri'

Net::HTTPResponse.class_eval do
  attr_reader :code # crap
end

module Steam
  module Connection
    class NetHttp
      def call(env)
        request  = Rack::Request.new(env)
        response = send(request.request_method.downcase, request)
        response = follow_redirect(response) if response.status.to_s[0, 1] == '3'
        response.to_a
      end
      
      def get(request)
        url      = URI.parse(request.url)
        response = Net::HTTP.start(url.host, url.port) { |http| http.get(url.path) }
        Rack::Response.new(response.body, response.code, response.to_hash)
      end
      
      def post(request)
        url      = URI.parse(request.url)
        params   = Rack::Utils.parse_query(Rack::Utils.build_nested_query(request.params))
        response = Net::HTTP.post_form(url, params)
        Rack::Response.new(response.body, response.code, response.to_hash)
      end
      
      def follow_redirect(response)
        location = response.headers['location'].join
        env      = Steam::Request.env_for(location)
        request  = Rack::Request.new(env)
        get(request)
      end
    end
  end
end