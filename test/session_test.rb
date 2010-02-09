require File.expand_path(File.dirname(__FILE__) + '/test_helper')
require 'erb'

class SessionTest < Test::Unit::TestCase
  include Steam

  def setup
    connection = Connection::Mock.new
    browser = Browser::HtmlUnit.new(connection)
    @session = Session.new(browser)
  end

  def test_session_responds_to_browser_methods
    assert @session.respond_to?(:call)
  end
end