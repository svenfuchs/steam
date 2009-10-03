require 'rack/response'

module Steam
  module Connection
    class Static < Rack::Static
      def initialize(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        options[:urls] ||= %w(/images /javascripts /stylesheets)
        app = args.pop
        super(app || lambda { Rack::Response.new('', 404).to_a }, options)
      end
      
      def call(env)
        status, headers, response = super
        case response
        when Rack::File
          Rack::Response.new(File.read(response.path), status, headers).to_a
        when Array
          Rack::Response.new(response.first, status, headers).to_a
        else
          [status, headers, response]
        end
      end
    end
  end
end