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

  test 'assert_contain' do
    @session.assert_contain(@session.response.body, 'bar!')
  end

  test 'assert_not_contain' do
    @session.assert_not_contain(@session.response.body, 'bar!!')
  end

  test 'assert_have_tag' do
    @session.assert_have_tag(@session.response.body, :a, 'bar!', :id => 'buz')
  end

  test 'assert_have_no_tag' do
    @session.assert_have_no_tag(@session.response.body, :a, 'bar!', :class => 'buz')
  end

  test 'assert_have_xpath' do
    @session.assert_have_xpath(@session.response.body, '//div/a[@id="buz"]')
  end

  test 'assert_have_no_xpath' do
    @session.assert_have_no_xpath(@session.response.body, '//div/a[@class="buz"]')
  end
end