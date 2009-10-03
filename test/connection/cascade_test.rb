require File.expand_path(File.dirname(__FILE__) + '/../test_helper')
require 'rack/cascade'

class ConnectionCascaseTest < Test::Unit::TestCase
  include TestHelper
  include Steam

  def setup
    @static_url = 'http://localhost:3000/javascripts/foo.js'
    @root = File.expand_path(File.dirname(__FILE__) + '/../fixtures')
    static = Connection::Static.new(:root => @root)

    @mock_url = 'http://localhost:3000/mock'
    mock = Connection::Mock.new
    mock.mock :get, @mock_url, 'mock body'

    @patron_url = 'http://localhost:3000/patron'
    patron = Connection::Patron.new
    patron.stubs(:handle_request).returns(patron_response('patron body')) # FIXME .with(...)

    @connection = Rack::Cascade.new([static, mock, patron])
  end
  
  def test_cascade
    status, headers, response = @connection.call(Request.env_for(@static_url))
    assert_equal File.read(@root + '/javascripts/foo.js'), response.body.join

    status, headers, response = @connection.call(Request.env_for(@mock_url))
    assert_equal 'mock body', response.body.join

    status, headers, response = @connection.call(Request.env_for(@patron_url))
    assert_equal 'patron body', response.body.join
  end
end