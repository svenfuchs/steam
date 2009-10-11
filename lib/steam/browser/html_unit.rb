module Steam
  module Browser
    class HtmlUnit
      autoload :Drb,        'steam/browser/html_unit/drb'
      autoload :Page,       'steam/browser/html_unit/page'
      autoload :Client,     'steam/browser/html_unit/client'
      autoload :Connection, 'steam/browser/html_unit/connection'

      include Matchers::HtmlUnit
      
      attr_accessor :client, :connection, :request, :response

      def initialize(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        connection = args.pop
        
        @client = options[:drb] ? Drb::Client.new : Client.new(connection, options)
      end
      
      def page
        client.page # TODO remove dependency?
      end
      
      def request(url)
        call Request.env_for(url)
      end
      alias :visit :request

      def call(env)
        @dom = nil
        @request = Rack::Request.new(env)
        # @page, @response = client.request(@request.url)
        status, headers, @response = client.request(@request.url)
        @response.to_a
      end

      def respond_to?(method)
        return true if client.respond_to?(method)
        super
      end

      def method_missing(method, *args, &block)
        return client.send(method, *args, &block) # if client.respond_to?(method)
        super
      end
    end
  end
end
