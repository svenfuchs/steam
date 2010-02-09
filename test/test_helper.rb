require 'test/unit'
require 'mocha'
require 'erb'

TEST_ROOT = File.expand_path("../", __FILE__)

$: << File.expand_path("../lib", TEST_ROOT)
$: << TEST_ROOT

FIXTURES_PATH = File.expand_path("../fixtures", __FILE__)

require 'steam'

# Steam::Java.import('com.gargoylesoftware.htmlunit.StringWebResponse')
# Steam::Java.import('com.gargoylesoftware.htmlunit.WebClient')
# Steam::Java.import('com.gargoylesoftware.htmlunit.TopLevelWindow')
# Steam::Java.import('com.gargoylesoftware.htmlunit.DefaultPageCreator')

class Test::Unit::TestCase
  def self.test(name, &block)
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

  def perform(method, url, response)
    @app.mock(method, url, response)
    @status, @headers, @response = @browser.call(Steam::Request.env_for(url))
  end

  def assert_response_contains(text, options = {})
    tag_name = options[:in] || 'body'
    response = yield
    assert_equal 200, response.status
    assert_match %r(<#{tag_name}>\s*#{text}\s*<\/#{tag_name}>), response.body
  end
end