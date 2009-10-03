require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

require 'patron'

Patron::Response.class_eval do
  def initialize(url = nil, status = nil, body = nil, headers = {})
    @url = url
    @status = status
    @body = body
    @headers = headers
  end
  remove_method :inspect
end

class PatronTest < Test::Unit::TestCase
  include Steam

  def setup
    @url = 'http://localhost:3000/foo'
    @http = Http::Patron.new
    @request = Request.new(@url)
    @response = Patron::Response.new(@url, '200', 'foo', 'content-type' => 'text/html')
    @http.stubs(:handle_request).returns(@response)
  end

  def test_returns_the_expected_response
    response = @http.get(@request)
    assert response.is_a?(Response)
    assert_equal 'foo', response.body
    assert_equal 200, response.status
    assert_equal 'text/html', response.status
  end
  
  def test_foo
    # @response.body = '<html><body><script>document.title = "FOO"</script></body></html>'
    # response = @browser.get(@request)
    # assert_match /^<\?xml/, response.body
  end
end