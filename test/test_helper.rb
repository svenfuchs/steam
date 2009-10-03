require 'test/unit'
require 'rubygems'
require 'mocha'
require 'pp'

TEST_ROOT = File.dirname(__FILE__)
PLUGIN_ROOT = File.expand_path(TEST_ROOT + "/..")
RAILS_ROOT = File.expand_path(PLUGIN_ROOT + "/../..")

$: << PLUGIN_ROOT + '/lib'

require 'steam'

class HttpMock
  attr_accessor :response
  
  def initialize(response)
    @response = response
  end
  
  [:get, :post, :put, :delete, :head].each do |method|
    define_method(method) { |*args| response }
  end
end

