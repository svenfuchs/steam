require 'rubygems'
require 'rjb'

module Steam
  module Browser
    class HtmlUnit
      attr_accessor :ui, :http, :page, :connection

      Java.import 'com.gargoylesoftware.htmlunit.WebClient'

      def initialize(http = nil, options = {})
        default_options = { :css => true, :javascript => true }
        options = default_options.merge(options)
        
        @connection = Steam::Connection::HtmlUnit.new(http || Steam::Connection::RestClient.new)

        @ui = Java::WebClient.new
        @ui.setCssEnabled(options[:css])
        @ui.setJavaScriptEnabled(options[:javascript])
        @ui.setWebConnection(Rjb::bind(connection, 'com.gargoylesoftware.htmlunit.WebConnection'))
      end

      [:get, :post, :put, :delete, :head].each do |method|
        define_method(method) { |*args| process(method, *args) }
      end

      protected

        def process(method, request)
          @page = ui.getPage(request.uri.to_s)  # FIXME include request headers etc
          Response.new(@page.asXml, 200, {})    # FIXME return a full response
        end
    end
  end
end