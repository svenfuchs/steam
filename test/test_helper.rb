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
  def assert_response_contains(text, options = {})
    tag_name = options[:in] || 'body'
    status, headers, response = yield
    assert_equal 200, status
    assert_match %r(<#{tag_name}>\s*#{text}\s*<\/#{tag_name}>), response.body.join
  end

  def page(html, url = 'http://localhost:3000/')
    url      = Steam::Java::Url.new(url)
    client   = Steam::Java::WebClient.new
    window   = Steam::Java::TopLevelWindow.new('window', client)
    response = Steam::Java::StringWebResponse.new(html, url)
    Steam::Java::DefaultPageCreator.new.createPage(response, window)
  end

  def patron_response(body)
    @response = Patron::Response.new
    @response.instance_eval do
      @body = body
    end
    @response
  end
end