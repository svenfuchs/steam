require 'test/unit'
require 'rubygems'
require 'mocha'
require 'pp'

TEST_ROOT = File.dirname(__FILE__)
PLUGIN_ROOT = File.expand_path(TEST_ROOT + "/..")

$: << PLUGIN_ROOT + '/lib'

require 'steam'

module TestHelper
  def assert_response_contains(text, options = {})
    tag_name = options[:in] || 'body'
    status, headers, response = yield
    assert_equal 200, status
    assert_match %r(<#{tag_name}>\s*#{text}\s*<\/#{tag_name}>), response.body.join
  end

  def patron_response(body)
    @response = Patron::Response.new
    @response.instance_eval do
      @body = body
    end
    @response
  end
end