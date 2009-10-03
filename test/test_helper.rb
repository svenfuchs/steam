require 'test/unit'
require 'rubygems'
require 'mocha'
require 'pp'

TEST_ROOT = File.dirname(__FILE__)
PLUGIN_ROOT = File.expand_path(TEST_ROOT + "/..")

$: << PLUGIN_ROOT + '/lib'

require 'steam'

module TestHelper
  
  def patron_response(body)
    @response = Patron::Response.new
    @response.instance_eval do
      @body = body
    end
    @response
  end
end