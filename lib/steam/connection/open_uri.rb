# This connection proxies requests using open-uri. 
#

require 'open-uri'

module Steam
  module Connection
    class OpenUri
      def call(env)
        request = Rack::Request.new(env)
        Rack::Response.new(*open(request.url)).to_a
      end
      
      def open(uri)
        headers = {}
        body = Kernel.open(uri) { |f| headers = f.meta; f.read }
        [body, 200, headers]
      rescue OpenURI::HTTPError => e
        status = e.message.split(' ').first
        ['', status, headers]
      end
    end
  end
end