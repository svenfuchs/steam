require File.expand_path(File.dirname(__FILE__) + '/test_helper')

class SessionTest < Test::Unit::TestCase
  include Steam

  def setup
    @connection = Connection::Mock.new
    @browser = Browser::HtmlUnit.new(@connection)
    @session = Session.new(@browser)

    perform(:get, 'http://localhost:3000/', '<div id="foo"><div id="bar"><a id="buz" href="">bar!</a></div></div>')
  end

  test 'session responds to browser methods' do
    assert @session.respond_to?(:response)
  end

  test 'assert_contain' do
    @session.assert_contain('bar!')
  end

  test 'assert_not_contain' do
    @session.assert_not_contain('bar!!')
  end

  test 'assert_have_tag' do
    @session.assert_have_tag(:a, 'bar!', :id => 'buz')
  end

  test 'assert_have_no_tag' do
    @session.assert_have_no_tag(:a, 'bar!', :class => 'buz')
  end

  test 'assert_have_xpath' do
    @session.assert_have_xpath('//div/a[@id="buz"]')
  end

  test 'assert_have_no_xpath' do
    @session.assert_have_no_xpath('//div/a[@class="buz"]')
  end
end