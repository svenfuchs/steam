require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

if Gem.available?('patron')
  class ConnectionPatronTest < Test::Unit::TestCase
    include TestHelper
    include Steam

    def setup
      @connection = Connection::Patron.new
      @url = 'http://localhost:3000/'
      @env = Request.env_for(@url)
      @request = Rack::Request.new(@env)
      @body = <<-body
        <html>
          <head>
            <script src="/javascripts/script.js" type="text/javascript"></script>
          </head>
        </html>
      body
    end

    def test_base_url
      @connection.stubs(:handle_request).returns(patron_response('body'))
      @connection.call(@env)
      assert_equal 'http://localhost:3000', @connection.base_url
    end

    def test_response
      @connection.stubs(:handle_request).returns(patron_response('body'))
      status, headers, response = @connection.call(@env)
      assert_equal ['body'], response.body
    end
  end
end