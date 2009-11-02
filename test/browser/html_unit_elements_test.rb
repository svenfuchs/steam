require File.expand_path(File.dirname(__FILE__) + '/../test_helper')
require 'erb'

class HtmlUnitElementsTest < Test::Unit::TestCase
  include Steam
  include TestHelper

  def html(*elements)
    scripts = ''
    fields  = ''
    elements.each do |element|
      case element
      when :field
        fields << '<input type="text" name="field" />'
      when :checkbox
        fields << '<input type="checkbox" name="checkbox" value="1" />'
      when :radio
        fields << '<input type="radio" name="radio" value="radio" />' \
               << '<input type="radio" name="radio" value="tv" />'
      when :select
        fields << '<select name="select"><option value=""></option><option value="foo">foo</option></select>'
      when :foo
        scripts << '<script src="/javascripts/foo.js" type="text/javascript"></script>'
      when :drag
        scripts << '<script src="/javascripts/jquery.js" type="text/javascript"></script>' \
                << '<script src="/javascripts/jquery-ui.js" type="text/javascript"></script>' \
                << '<script src="/javascripts/drag.js" type="text/javascript"></script>'
      end
    end

    html = <<-erb
      <html>
        <head><%= scripts %></head>
        <body>
          <p><a href="/link" id="link">link</a></p>
          <form action="/form" method="get" id="form">
            <%= fields %>
            <input type="submit" value="button" />
          </form>
        </body>
      </html>
    erb

    ERB.new(html).result(binding)
  end

  def setup
    @mock = Connection::Mock.new

    root = File.expand_path(File.dirname(__FILE__) + '/../fixtures')
    static = Connection::Static.new(:root => root)

    connection = Rack::Cascade.new([static, @mock])
    @browser = Browser::HtmlUnit.new(connection)
  end

  def perform(method, url, response)
    @mock.mock(method, url, response)
    @status, @headers, @response = @browser.call(Request.env_for(url))
  end

  def test_click_on_clicks_a_link
    perform :get, 'http://localhost:3000/', html

    element = @browser.locate_element('link')

    assert_response_contains('LINK') do
      @mock.mock :get, 'http://localhost:3000/link', 'LINK'
      @browser.click_on(element)
    end
  end

  def test_click_on_clicks_a_button
    perform :get, 'http://localhost:3000/', html(:field)

    element = @browser.locate_element('button')

    assert_response_contains('FORM') do
      @mock.mock :get, 'http://localhost:3000/form?field=', 'FORM'
      @browser.click_on(element)
    end
  end

  def test_click_link
    perform :get, 'http://localhost:3000/', html(:foo)

    element = @browser.locate_element('link')

    assert_response_contains('LINK') do
      @mock.mock :get, 'http://localhost:3000/link', 'LINK'
      @browser.click_link(element)
    end
  end

  def test_click_button
    perform :get, 'http://localhost:3000/', html(:field)

    element = @browser.locate_element('button')

    assert_response_contains('FORM') do
      @mock.mock :get, 'http://localhost:3000/form?field=', 'FORM'
      @browser.click_button(element)
    end
  end

  def test_submit_form
    perform :get, 'http://localhost:3000/', html(:field)

    element = @browser.locate_element('form')

    assert_response_contains('FORM') do
      @mock.mock :get, 'http://localhost:3000/form?field=', 'FORM'
      @browser.submit_form(element)
    end
  end

  def test_fill_in
    perform :get, 'http://localhost:3000/', html(:field)

    element = @browser.locate_element('field')

    assert_response_contains('FIELD') do
      @mock.mock :get, 'http://localhost:3000/form?field=field', 'FIELD'
      @browser.fill_in(element, :with => 'field')
      @browser.submit_form('form')
    end
  end

  def test_check
    perform :get, 'http://localhost:3000/', html(:checkbox)

    element = @browser.locate_element('checkbox')
    form    = @browser.locate_element('form')

    assert_response_contains('CHECKED') do
      @mock.mock :get, 'http://localhost:3000/form?checkbox=1', 'CHECKED'
      @browser.check(element)
      @browser.submit_form(form)
    end
  end

  def test_uncheck
    perform :get, 'http://localhost:3000/', html(:checkbox)

    element = @browser.locate_element('checkbox')
    form    = @browser.locate_element('form')

    assert_response_contains('FORM') do
      @mock.mock :get, 'http://localhost:3000/form', 'FORM'
      @browser.check(element)
      @browser.uncheck(element)
      @browser.submit_form(form)
    end
  end

  def test_choose
    perform :get, 'http://localhost:3000/', html(:radio)

    element = @browser.locate_element('radio')
    form    = @browser.locate_element('form')

    assert_response_contains('RADIO') do
      @mock.mock :get, 'http://localhost:3000/form?radio=radio', 'RADIO'
      @browser.choose(element)
      @browser.submit_form(form)
    end
  end

  def test_select
    perform :get, 'http://localhost:3000/', html(:select)

    option_element = @browser.locate_element('foo')
    select_element = @browser.locate_element('select')
    form           = @browser.locate_element('form')

    assert_response_contains('SELECT') do
      @mock.mock :get, 'http://localhost:3000/form?select=foo', 'SELECT'
      @browser.select(option_element, :from => select_element)
      @browser.submit_form(form)
    end
  end

  def test_drag_and_drop
    perform :get, 'http://localhost:3000/', html(:drag)

    drag_element = @browser.locate_element('link')
    drop_element = @browser.locate_element('form')

    @browser.drag(drag_element)
    @browser.drop(drop_element)
    assert_equal 'DROPPED!', @browser.page.getTitleText
  end
end