require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class HtmlUnitTest < Test::Unit::TestCase
  include Steam

  def setup
    Browser::HtmlUnit::MockConnection.public_dir = File.dirname(__FILE__) + '/../fixtures'
    
    @request = Request.new('http://localhost:3000/')
    @response = Response.new
    @http = HttpMock.new(@response)
    @browser = Browser::HtmlUnit.new(@http)
  end

  # def test_browser_processes_response_body_through_htmlunit
  #   @response.body = '<html><body><script>document.title = "FOO"</script></body></html>'
  #   response = @browser.get(@request)
  #   assert_match /^<\?xml/, response.body
  # end
  # 
  # def test_browser_evaluates_javascript
  #   @response.body = '<html><body><script>document.title = "FOO"</script></body></html>'
  #   @browser.get(@request)
  #   assert_match 'FOO', @browser.page.getTitleText
  # end

  def test_browser_loads_linked_javascripts
    @response.body = '<html><head><script src="/javascripts/foo.js" type="text/javascript"></script></head></html>'
    # @http.expects(:get).with('/javascript/foo.js')
    # @browser.connection.connection.setResponse(Steam::Browser::HtmlUnit::Java::Url.new('http://localhost:3000/javascripts/foo.js'), '// foo', 'application/javascript')
    puts @browser.get(@request).body
  end
end