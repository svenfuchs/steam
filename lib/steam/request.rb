require 'uri'

module Steam
  class Request < Rack::Request
    attr_accessor :method, :headers

    DEFAULT_ENV = {
      "rack.version"      => [0, 1],
      "rack.input"        => StringIO.new,
      "rack.errors"       => StringIO.new,
      "rack.multithread"  => true,
      "rack.multiprocess" => true,
      "rack.run_once"     => false,
    }

    class << self
      def env_for(uri = '', opts = {})
        env   = DEFAULT_ENV.dup
        uri   = URI.parse(uri)
        input = opts[:input] || ''

        env.merge!(
          'REQUEST_METHOD'   => opts[:method] || 'GET',
          'SERVER_NAME'      => 'localhost',
          'SERVER_PORT'      => '3000',
          'QUERY_STRING'     => uri.query.to_s,
          'PATH_INFO'        => (!uri.path || uri.path.empty?) ? '/' : uri.path,
          'rack.url_scheme'  => 'http',
          'SCRIPT_NAME'      => opts[:script_name] || '',
          'rack.errors'      => StringIO.new,
          'rack.input'       => input.is_a?(String) ? StringIO.new(input) : input,
          'CONTENT_LENGTH'   => env['rack.input'].length.to_s,
          'rack.test.scheme' => uri.scheme || 'http',
          'rack.test.host'   => uri.host   || 'www.example.com',
          'rack.test.port'   => uri.port,
          'rack.test.cache_classes' => true
        )
        # env.merge! Hash[*opts.select { |key, value| key.is_a?(String) }.flatten]
        env
      end
    end

    def initialize(method, uri, opts = {})
      env = self.class.env_for(uri, opts.merge(:method => method))
      super(env)
    end
  end
end