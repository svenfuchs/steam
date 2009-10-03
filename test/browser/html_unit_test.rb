require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class HtmlUnitTest < Test::Unit::TestCase
  include Steam

  def setup
    mock = Connection::Mock.new
    mock.mock :get, 'http://localhost:3000/', <<-body
      <html>
        <head>
          <script src="/javascripts/foo.js" type="text/javascript"></script>
        </head>
      </html>
    body

    root = File.expand_path(File.dirname(__FILE__) + '/../fixtures')
    static = Connection::Static.new(:root => root)

    connection = Rack::Cascade.new([static, mock])
    @browser = Browser::HtmlUnit.new(connection)
  end

  def test_browser_loads_and_evaluates_linked_javascripts
    status, headers, response = get('http://localhost:3000/')
    assert_match %r(<title>\s*FOO\s*<\/title>), response.body.join
  end

  protected

    def get(url)
      @browser.call(Request.env_for(url))
    end
end