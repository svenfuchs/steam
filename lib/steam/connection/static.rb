require 'rack/response'

module Steam
  module Connection
    class Static < Rack::Static
      def initialize(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        options[:urls] ||= %w(/images /javascripts /stylesheets)
        app = args.pop
        super(app || lambda { response_404 }, options)
      end

      def call(env)
        status, headers, response = super

        response = case response
        when Rack::File
          Rack::Response.new(::File.read(response.path), status, headers).to_a
        when Array
          Rack::Response.new(response.first, status, headers).to_a
        else
          [status, headers, response]
        end

        response
      end

      def response_404
        Rack::Response.new('', 404).to_a
      end
    end
  end
end