require 'test/unit'
require 'mocha'
require 'erb'

TEST_ROOT = File.expand_path("../", __FILE__)

$: << File.expand_path("../lib", TEST_ROOT)
$: << TEST_ROOT

FIXTURES_PATH = File.expand_path("../fixtures", __FILE__)

require 'steam'
require 'ruby-debug'

# Steam::Java.import('com.gargoylesoftware.htmlunit.StringWebResponse')
# Steam::Java.import('com.gargoylesoftware.htmlunit.WebClient')
# Steam::Java.import('com.gargoylesoftware.htmlunit.TopLevelWindow')
# Steam::Java.import('com.gargoylesoftware.htmlunit.DefaultPageCreator')

module TestMethod
  def self.included(base)
    base.class_eval do
      def test(name, &block)
        test_name = "test_#{name.gsub(/\s+/,'_')}".to_sym
        defined = instance_method(test_name) rescue false
        raise "#{test_name} is already defined in #{self}" if defined
        if block_given?
          define_method(test_name, &block)
        else
          define_method(test_name) do
            flunk "No implementation provided for #{name}"
          end
        end
      end
    end
  end
end

class Module
  include TestMethod
end

class Test::Unit::TestCase
  include TestMethod

  def mock(method, url, response)
    connection = @browser.connection
    connection = connection.apps.last if connection.is_a?(Rack::Cascade)
    connection.mock(method, url, response)
  end

  def perform(method, url, response)
    mock(method, url, response)
    @status, @headers, @response = @browser.send(method, url)
    [@status, @headers, @response]
  end

  def assert_response_contains(text, options = {})
    tag_name = options[:in] || 'body'
    response = yield
    assert_equal 200, response.status
    assert_match %r(<#{tag_name}>\s*#{text}\s*<\/#{tag_name}>), response.body
  end

  def assert_passes
    begin
      yield
    rescue Test::Unit::AssertionFailedError => e
    ensure
      assert_nil e
    end
  end

  def assert_fails
    begin
      yield
    rescue Test::Unit::AssertionFailedError => e
    ensure
      assert_not_nil e
    end
  end
end