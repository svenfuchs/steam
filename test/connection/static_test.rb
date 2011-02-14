require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class ConnectionStaticTest < Test::Unit::TestCase
  include Steam

  def test_static
    url  = 'http://localhost:3000/javascripts/foo.js'
    root = File.expand_path(File.dirname(__FILE__) + '/../fixtures')
    connection = Connection::Static.new(:root => root)

    status, headers, response = connection.call(Request.new(:url => url).env)
    assert_equal File.read(root + '/javascripts/foo.js'), response.body.join
  end
end