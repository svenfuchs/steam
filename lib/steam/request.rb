require 'uri'

module Steam
  class Request
    attr_accessor :method, :uri, :params, :headers

    def initialize(uri, params = {}, headers = {})
      uri      = URI.parse(uri)
      @uri     = rewrite_uri(uri)
      @params  = params
      @headers = normalize_headers(uri, headers)
    end
    
    def host_with_port
      "#{uri.scheme}://#{uri.host}" + (uri.port ? ":#{uri.port}" : '')
    end
    
    def path
      uri.path
    end
    
    protected

      def normalize_headers(uri, headers)
        headers.merge 'rack.test.scheme' => uri.scheme || 'http',
                      'rack.test.host'   => uri.host   || 'www.example.com',
                      'rack.test.port'   => uri.port,
                      'rack.test.cache_classes' => true
      end

      def rewrite_uri(uri)
        uri.scheme = 'http'
        uri.host   = 'localhost'
        uri.port   = '3000'
        uri
      end
  end
end