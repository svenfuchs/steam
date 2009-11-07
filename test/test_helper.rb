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
        fields << '<input type="text" name="field" />'
      when :textarea
        fields << '<textarea name="textarea"></textarea>'
      when :checkbox
        fields << '<input type="checkbox" name="checkbox" value="1" />'
      when :radio
        fields << '<input type="radio" name="radio" value="radio" />' \
               << '<input type="radio" name="radio" value="tv" />'
      when :select
        fields << '<select name="select"><option value=""></option><option value="foo">foo</option></select>'
      when :file
        fields << '<input type="file" name="file" />'
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

