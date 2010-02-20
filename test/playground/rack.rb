require 'rubygems'
require 'rack'
require 'rack/file'
require 'rack/mock'

include Rack

rack = File.new(File.dirname(__FILE__) + '/fixtures')
env  = MockRequest.env_for('http://localhost:3000/javascripts/foo.js')
response = rack.call(env)
p response[2].path
