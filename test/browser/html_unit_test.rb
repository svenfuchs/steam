require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class HtmlUnitTest < Test::Unit::TestCase
  include Steam
  include TestHelper

  def page
    <<-html
      <html>
        <head>
          <script src="/javascripts/foo.js" type="text/javascript"></script>
        </head>
        <body>
          <a href="/">Home</a>
          <p>Welcome!</p>
          <p>Now, click the <a href="/link">link</a>!</p>
          <form action="/form" method="get" id="form">
            <input type="text" name="field" />
            <input type="checkbox" name="checkbox" value="1" />
            <input type="radio" name="radio" value="radio" />
            <input type="radio" name="radio" value="tv" />
            <select name="select"><option value=""></option><option value="foo">foo</option></select>
            <input type="submit" value="button" />
          </form>
        </body>
      </html>
    html
  end

  def setup
    @mock = Connection::Mock.new
    @mock.mock :get, 'http://localhost:3000/', page

    root = File.expand_path(File.dirname(__FILE__) + '/../fixtures')
    static = Connection::Static.new(:root => root)

    connection = Rack::Cascade.new([static, @mock])
    @browser = Browser::HtmlUnit.new(connection)
    @status, @headers, @response = @browser.call(Request.env_for('http://localhost:3000/'))
  end

  def test_browser_loads_and_evaluates_linked_javascripts
    assert_match %r(<title>\s*FOO\s*<\/title>), @response.body.join
  end

  def test_click_link
    @mock.mock :get, 'http://localhost:3000/link', 'LINK'

    assert_response_contains('LINK') do
      @browser.click_link('link')
    end
  end

  def test_click_button
    @mock.mock :get, 'http://localhost:3000/form?field=&select=', 'FORM'

    assert_response_contains('FORM') do
      @browser.click_button('button')
    end
  end

  def test_submit_form
    @mock.mock :get, 'http://localhost:3000/form?field=&select=', 'FORM'

    assert_response_contains('FORM') do
      @browser.submit_form('form')
    end
  end

  def test_fill_in
    @mock.mock :get, 'http://localhost:3000/form?field=field&select=', 'FIELD'

    assert_response_contains('FIELD') do
      @browser.fill_in('field', :with => 'field')
      @browser.submit_form('form')
    end
  end

  def test_check
    @mock.mock :get, 'http://localhost:3000/form?field=&checkbox=1&select=', 'CHECKED'

    assert_response_contains('CHECKED') do
      @browser.check('checkbox')
      @browser.submit_form('form')
    end
  end

  def test_uncheck
    @mock.mock :get, 'http://localhost:3000/form?field=&select=', 'FORM'

    assert_response_contains('FORM') do
      @browser.check('checkbox')
      @browser.uncheck('checkbox')
      @browser.submit_form('form')
    end
  end

  def test_choose
    @mock.mock :get, 'http://localhost:3000/form?field=&radio=radio&select=', 'RADIO'

    assert_response_contains('RADIO') do
      @browser.choose('radio')
      @browser.submit_form('form')
    end
  end

  def test_select
    @mock.mock :get, 'http://localhost:3000/form?field=&select=foo', 'SELECT'

    assert_response_contains('SELECT') do
      @browser.select('foo', :from => 'select')
      @browser.submit_form('form')
    end
  end
end