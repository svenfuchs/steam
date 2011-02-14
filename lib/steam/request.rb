# Extends a Rack::Request with a few convenience methods

require 'uri'

module Steam
  class Request < Rack::Request
    attr_reader :method

    class << self
      def default_env
        @default_env ||= {
          'REQUEST_METHOD'    => 'GET',
          'SERVER_NAME'       => Steam.config[:server_name],
          'SERVER_PORT'       => Steam.config[:server_port],
          'rack.url_scheme'   => Steam.config[:url_scheme],
          'rack.version'      => [0, 1],
          'rack.input'        => StringIO.new,
          'rack.errors'       => StringIO.new,
          'rack.multithread'  => true,
          'rack.multiprocess' => true,
          'rack.run_once'     => false,
          'rack.test.scheme'  => Steam.config[:url_scheme],
          'rack.test.host'    => 'www.example.com',
          'rack.test.cache_classes' => true
        }
        @default_env.dup
      end
    end

    def initialize(env = {})
      super(self.class.default_env)
      update(env)
    end

    def update(options = {})
      options.each { |name, value| send("#{name}=", value) }
    end
    
    def env
      super.merge(headers)
    end

    def url=(url)
      url = URI.parse(url)
      self.path   = url.path
      self.scheme = url.scheme if url.scheme
      self.host   = url.host   if url.host
      self.port   = url.port   if url.port
      self.query  = url.query  if url.query
    end
    alias :uri :url
    alias :uri= :url=

    def method=(method)
      @env.merge!(
        'REQUEST_METHOD' => method
      )
    end
    
    def scheme=(scheme)
      @env.merge!(
        'rack.url_scheme'  => scheme,
        'rack.test.scheme' => scheme
      )
      self.port = nil # reset the port so we switch according to the protocol
    end
    alias :protocol :scheme
    alias :protocol= :scheme=
    
    def host=(host)
      host, self.port = host.split(':')
      @env.merge!(
        'HTTP_HOST'      => host,
        'rack.test.host' => host
      )
    end
    
    def port=(port)
      port ||= protocol == 'https' ? 443 : 80
      @env.merge!(
        'SERVER_PORT'    => port,
        'rack.test.port' => port
      )
    end
    
    def query=(query)
      @env.merge!(
        'QUERY_STRING' => query.to_s
      )
    end
    
    def path=(path)
      @env.merge!(
        'PATH_INFO' => path && !path.empty? ? path : '/'
      )
    end

    def headers=(headers)
      self.headers.merge!(headers)
    end
    
    def headers
      @headers ||= {}
    end

    def input=(input)
      @env.merge!(
        'rack.input'     => input.is_a?(String) ? StringIO.new(input) : input,
        'CONTENT_LENGTH' => input.length.to_s
      )
    end
  end
end