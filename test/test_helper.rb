require 'test/unit'
require 'rubygems'
require 'mocha'
require 'pp'

TEST_ROOT = File.dirname(__FILE__)
PLUGIN_ROOT = File.expand_path(TEST_ROOT + "/..")

$: << PLUGIN_ROOT + '/lib'

require 'steam'

Steam::Java.import('com.gargoylesoftware.htmlunit.StringWebResponse')
Steam::Java.import('com.gargoylesoftware.htmlunit.WebClient')
Steam::Java.import('com.gargoylesoftware.htmlunit.TopLevelWindow')
Steam::Java.import('com.gargoylesoftware.htmlunit.DefaultPageCreator')

module TestHelper
  attr_reader :page

  def assert_response_contains(text, options = {})
    tag_name = options[:in] || 'body'
    status, headers, response = yield
    assert_equal 200, status
    assert_match %r(<#{tag_name}>\s*#{text}\s*<\/#{tag_name}>), response.body.join
  end

  def dom(html)
    Steam::Dom::Nokogiri::Page.new(html)
  end

  def patron_response(body)
    @response = Patron::Response.new
    @response.instance_eval do
      @body = body
    end
    @response
  end
end

module HtmlUnitHelper
  def html(*elements)
    scripts = ''
    fields  = ''
    elements.each do |element|
      case element
      when :field
        fields << '<label for="field">Label for field</label><input type="text" id="field" name="field" />'
      when :textarea
        fields << '<label for="textarea">Label for textarea</label><textarea id="textarea" name="textarea"></textarea>'
      when :checkbox
        fields << '<label for="checkbox">Label for checkbox</label><input id="checkbox" type="checkbox" name="checkbox" value="1" />'
      when :radio
        fields << '<label for="radio1">Label for radio</label><input id="radio1" type="radio" name="radio" value="radio" />' \
               << '<label for="radio2">Label for tv</label><input id="radio2" type="radio" name="radio" value="tv" />'
      when :select
        fields << '<label for="select">Label for select</label><select id="select" name="select"><option value=""></option><option value="foo">foo</option></select>'
      when :file
        fields << '<label for="file">Label for file</label><input id="file" type="file" name="file" />'
      when :date
        fields << '<select id="date_1i" name="date(1i)"><option value="2008">2008</option><option value="2009">2009</option><option value="2010">2010</option></select>' \
               << '<select id="date_2i" name="date(2i)"><option value="10">October</option><option value="11">November</option><option value="12">December</option></select>' \
               << '<select id="date_3i" name="date(3i)"><option value="6">6</option><option value="7">7</option><option value="8">8</option></select>'
      when :datetime
        fields << '<select id="datetime_1i" name="datetime(1i)"><option value="2008">2008</option><option value="2009">2009</option><option value="2010">2010</option></select>' \
               << '<select id="datetime_2i" name="datetime(2i)"><option value="10">October</option><option value="11">November</option><option value="12">December</option></select>' \
               << '<select id="datetime_3i" name="datetime(3i)"><option value="6">6</option><option value="7">7</option><option value="8">8</option></select> : ' \
               << '<select id="datetime_4i" name="datetime(4i)"><option value="18">18</option><option value="19">19</option><option value="20">20</option></select>' \
               << '<select id="datetime_5i" name="datetime(5i)"><option value="0">00</option><option value="1">01</option><option value="2">02</option></select>'
      when :time
        fields << '<select id="time_4i" name="time(4i)"><option value="18">18</option><option value="19">19</option><option value="20">20</option></select>' \
               << '<select id="time_5i" name="time(5i)"><option value="0">00</option><option value="1">01</option><option value="2">02</option></select>'
      when :jquery
        scripts << '<script src="/javascripts/jquery.js" type="text/javascript"></script>'
      when :jquery_ui
        scripts << '<script src="/javascripts/jquery-ui.js" type="text/javascript"></script>'
      when :foo
        scripts << '<script src="/javascripts/foo.js" type="text/javascript"></script>'
      when :hover
        scripts << '<script src="/javascripts/hover.js" type="text/javascript"></script>'
      when :blur
        scripts << '<script src="/javascripts/blur.js" type="text/javascript"></script>'
      when :focus
        scripts << '<script src="/javascripts/focus.js" type="text/javascript"></script>'
      when :double_click
        scripts << '<script src="/javascripts/double_click.js" type="text/javascript"></script>'
      when :drag
        scripts << '<script src="/javascripts/drag.js" type="text/javascript"></script>'
      end
    end

    html = <<-erb
      <html>
        <head><%= scripts %></head>
        <body>
          <p id="paragraph"></p>
          <p><a href="/link" id="link">link</a></p>
          <form action="/form" method="get" id="form" enctype="multipart/form-data">
            <%= fields %>
            <input type="submit" value="button" />
          </form>
        </body>
      </html>
    erb

    ERB.new(html).result(binding)
  end

  def setup
    @mock = Steam::Connection::Mock.new

    root = File.expand_path(TEST_ROOT + '/fixtures')
    static = Steam::Connection::Static.new(:root => root)

    connection = Rack::Cascade.new([static, @mock])
    @browser = Steam::Browser::HtmlUnit.new(connection)
  end

  def perform(method, url, response)
    @mock.mock(method, url, response)
    @status, @headers, @response = @browser.call(Steam::Request.env_for(url))
  end
end

class LocatorTest < Test::Unit::TestCase
  include Steam
  include Steam::Locators
  include TestHelper

  attr_reader :response, :page

  def setup
    @response = Rack::Response.new
  end

  def default_test
  end
end

class NokogiriLocatorTest < LocatorTest
  def setup
    @old_strategy = Steam::Locators.strategy
    Steam::Locators.strategy = :nokogiri
    super
  end

  def teardown
    Steam::Locators.strategy = @old_strategy
  end

  def dom(html)
    Dom::Nokogiri::Page.build(nil, html)
  end
end

class HtmlUnitLocatorTest < LocatorTest
  def setup
    @old_strategy = Steam::Locators.strategy
    Steam::Locators.strategy = :html_unit
    super
  end

  def teardown
    Steam::Locators.strategy = @old_strategy
  end

  def dom(html)
    Dom::HtmlUnit::Page.build(nil, html)
  end
end

