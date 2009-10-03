require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class ConnectionMockTest < Test::Unit::TestCase
  include Steam

  def setup
    @connection = Connection::Mock.new
    @url  = 'http://localhost:3000/'
    @body = <<-body
      <html>
        <head>
          <script src="/javascripts/script.js" type="text/javascript"></script>
        </head>
      </html>
    body
  end
  
  def test_call
    @connection.mock(:get, @url, @body)
    status, headers, response = @connection.call(Request.env_for(@url))
    assert_equal [@body], response.body
  end

  def test_mock_with_response
    @connection.mock(:get, @url, Rack::Response.new(@body, 200, { 'Content-Type' => 'text/css' }))
    assert_response('Content-Type' => 'text/css')
  end

  def test_mock_with_string
    @connection.mock(:get, @url, @body)
    assert_response
  end

  def test_mock_with_array_without_content_type
    @connection.mock(:get, @url, [@body, 201, { 'foo' => 'bar' }])
    assert_response(201, 'foo' => 'bar')
  end

  def test_mock_with_array_with_content_type
    @connection.mock(:get, @url, [@body, 201, { 'Content-Type' => 'text/css' }])
    assert_response(201, 'Content-Type' => 'text/css')
  end
  
  protected
  
    def assert_response(*args)
      headers = args.last.is_a?(Hash) ? args.pop : {}
      headers = { 'Content-Type' => 'text/html' }.merge(headers)
      status = args.pop || 200

      response = @connection.response('GET', @url)

      assert response.is_a?(Rack::Response)
      assert_equal [@body], response.body
      assert_equal status, response.status
      assert_equal headers['Content-Type'], response.header['Content-Type']
    end
end