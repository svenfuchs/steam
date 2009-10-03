require 'test/unit'
require 'rubygems'
require 'mocha'
require 'pp'

TEST_ROOT = File.dirname(__FILE__)
PLUGIN_ROOT = File.expand_path(TEST_ROOT + "/..")
RAILS_ROOT = File.expand_path(PLUGIN_ROOT + "/../..")

$: << PLUGIN_ROOT + '/lib'

require 'steam'

class MockConnection
  attr_accessor :responses
  
  def initialize(responses = {})
    @responses = responses
  end
  
  [:get, :post, :put, :delete, :head].each do |method|
    define_method(method) do |request|
      responses[request.url]
    end
  end
  
  def mock_response(type, responses)
    content_types = {
      :html => 'text/html',
      :javascript => 'application/javascript'
    }
    responses.each do |url, body|
      @responses[url] = Rack::Response.new(body, 200, 'Content-Type' => content_types[type])
    end
  end
end

