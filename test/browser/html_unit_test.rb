require File.expand_path('../../test_helper', __FILE__)
require 'fixtures/html_fakes'
require 'locator'

class HtmlUnitTest < Test::Unit::TestCase
  include Steam

  attr_reader :browser

  def setup
    @connection = Connection::Mock.new
    @browser = Browser::HtmlUnit.new(@connection)
    perform(:get, 'http://test.host/', '<div id="foo"><div id="bar"><a id="buz" href="">bar!</a></div></div>')
  end

  def locate(*args, &block)
    browser.locate(*args, &block)
  end

  def within(*args, &block)
    browser.within(*args, &block)
  end

  test 'subsequent requests stick to the initial hostname' do
    mock(:get, 'http://www.example.com/host', 'www.example.com')
    mock(:get, 'http://example.com/host', 'example.com')

    browser.request.port = nil
    browser.request.host = 'www.example.com'
    assert_match /www.example.com/, browser.get('/host').last.body
    browser.request.host = 'example.com'
    assert_match /example.com/, browser.get('/host').last.body
  end

  test 'subsequent requests stick to the initial protocol' do
    mock(:get, 'https://test.host/protocol', 'https')
    mock(:get, 'http://test.host/protocol', 'http')

    browser.request.protocol = 'https'
    assert_match /https/, browser.get('/protocol').last.body
    browser.request.protocol = 'http'
    assert_match /http/, browser.get('/protocol').last.body
  end

  test 'using an alert handler' do
    browser.set_handler(:alert) { |page, message| @alerted = message == 'FOO!' }
    browser.execute('alert("FOO!");')
    assert @alerted
  end

  test 'using an confirm handler' do
    browser.set_handler(:alert)   { |page, message| @alerted = true }
    browser.set_handler(:confirm) { |page, message| message == 'bar?' }

    browser.execute('if(confirm("foo?")) alert("");')
    assert !@alerted

    browser.execute('if(confirm("bar?")) alert("");')
    assert @alerted
  end

  test 'adding a cookie' do
    browser.add_cookie('foo', 'bar')
    assert_equal 'bar', browser.get_cookie('foo')
  end

  test 'clearing cookies' do
    browser.add_cookie('foo', 'bar')
    browser.clear_cookies
    assert_equal nil, browser.get_cookie('foo')
  end

  # LOCATE

  test 'locate with node type' do
    element = locate(:a)
    assert_equal 'a', element.name
  end

  test 'locate with attributes' do
    element = locate(:id => 'buz')
    assert_equal 'a', element.name
  end

  test 'locate with search text' do
    element = locate(:a, 'bar!')
    assert_equal 'a', element.name
  end

  test 'locate with xpath' do
    element = locate(:xpath => '//div/div/a')
    assert_equal 'a', element.name
  end

  test 'locate with css' do
    element = locate(:css => '#foo #bar a')
    assert_equal 'a', element.name
  end

  # WITHIN

  test 'within with node type' do
    element = within(:div) { within(:div) { locate(:a) } }
    assert_equal 'a', element.name
  end

  test 'within with attributes' do
    element = within(:id => 'foo') { within(:id => 'bar') { locate(:a) } }
    assert_equal 'a', element.name
  end

  test 'within with xpath' do
    element = within('//div/div') { locate(:a) }
    assert_equal 'a', element.name
  end

  test 'within with css' do
    element = within('#foo #bar') { locate(:a) }
    assert_equal 'a', element.name
  end

  test 'nesting locate' do
    element = locate(:id => 'foo') { locate(:id => 'bar') { locate(:a) } }
    assert_equal 'a', element.name
  end

  test 'nesting within' do
    element = within(:id => 'foo') { within(:id => 'bar') { locate(:a) } }
    assert_equal 'a', element.name
  end
end
