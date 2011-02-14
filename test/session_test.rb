require File.expand_path('../test_helper', __FILE__)

class SessionTest < Test::Unit::TestCase
  include Steam

  def setup
    @browser = Browser::HtmlUnit.new(Connection::Mock.new)
    @session = Session.new(@browser)

    perform(:get, 'http://localhost:3000/', '<div id="foo"><div id="bar"><a id="buz" href="">bar!</a></div></div>')
  end

  test 'session responds to browser methods' do
    assert @session.respond_to?(:response)
  end

  test 'assert_contains' do
    @session.assert_contains(@session.response.body, 'bar!')
  end

  test 'assert_does_not_contain' do
    @session.assert_does_not_contain(@session.response.body, 'bar!!')
  end

  test 'assert_has_tag' do
    @session.assert_has_tag(@session.response.body, :a, 'bar!', :id => 'buz')
  end

  test 'assert_no_tag' do
    @session.assert_no_tag(@session.response.body, :a, 'bar!', :class => 'buz')
  end

  test 'assert_has_xpath' do
    @session.assert_has_xpath(@session.response.body, '//div/a[@id="buz"]')
  end

  test 'assert_no_xpath' do
    @session.assert_no_xpath(@session.response.body, '//div/a[@class="buz"]')
  end
end
