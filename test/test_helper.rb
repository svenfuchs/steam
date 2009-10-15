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

