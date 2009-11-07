require File.expand_path(File.dirname(__FILE__) + '/../test_helper')
require 'rack/cascade'

class ConnectionCascadeTest < Test::Unit::TestCase
  include TestHelper
  include Steam

  def setup
    connections = []
    @urls = []
    @bodies = []

    @root = File.expand_path(File.dirname(__FILE__) + '/../fixtures')
    connections << Connection::Static.new(:root => @root)
    @urls << 'http://localhost:3000/javascripts/foo.js'
    @bodies << File.read(@root + '/javascripts/foo.js')

    @mock_url = 'http://localhost:3000/mock'
    mock = Connection::Mock.new
    mock.mock :get, @mock_url, 'mock body'
    connections << mock
    @urls << @mock_url
    @bodies << 'mock body'

    if Gem.available?('patron')
      patron = Connection::Patron.new
      patron_body = 'patron body'
      patron.stubs(:handle_request).returns(patron_response(patron_body)) # FIXME .with(...)
      connections << patron
      @urls << 'http://localhost:3000/patron'
      @bodies << patron_body
    end

    @connection = Rack::Cascade.new(connections)
  end

  def test_cascade
    @urls.each_with_index do |url, index|
      status, headers, response = @connection.call(Request.env_for(url))
      assert_equal @bodies[index], response.body.join
    end
  end
end