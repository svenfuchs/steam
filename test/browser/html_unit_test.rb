require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class HtmlUnitTest < Test::Unit::TestCase
  include Steam

  def setup
    @connection = MockConnection.new
    @browser = Browser::HtmlUnit.new(@connection)
  end

  def test_browser_loads_and_evaluates_linked_javascripts
    mock_response :html, 'http://localhost:3000/' => <<-body
      <html>
        <head>
          <script src="/javascripts/script.js" type="text/javascript"></script>
        </head>
      </html>
    body

    mock_response :javascript, 'http://localhost:3000/javascripts/script.js' => <<-body
      document.title = "FOO"
    body

    request  = Request.new('GET', 'http://localhost:3000/')
    response = @browser.process(request)
    p response.status
    assert_match /FOO/, response.body.join
  end

  def mock_response(type, responses)
    @connection.mock_response(type, responses)
  end
end