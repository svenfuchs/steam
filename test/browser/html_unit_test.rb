require File.expand_path('../../test_helper', __FILE__)
require 'fixtures/html_fakes'
require 'locator'

module HtmlUnitTests
  def init
    @app = Steam::Connection::Mock.new
    static = Steam::Connection::Static.new(:root => FIXTURES_PATH)
    @browser = Steam::Browser::HtmlUnit.new(Rack::Cascade.new([static, @app]))
    perform(:get, 'http://localhost:3000/', '<div id="foo"><div id="bar"><a id="buz" href="">bar!</a></div></div>')
  end
  
  def locate(*args, &block)
    @browser.locate(*args, &block)
  end
  
  def within(*args, &block)
    @browser.within(*args, &block)
  end
  
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

class HtmlUnitWithNokogiriAdapterTest < Test::Unit::TestCase
  include Steam, HtmlUnitTests

  def setup
    init
  end
end

class HtmlUnitWithHtmlUnitAdapterTest < Test::Unit::TestCase
  include Steam, HtmlUnitTests

  def setup
    @old_adapter, Locator::Dom.adapter = Locator::Dom.adapter, Locator::Dom::Htmlunit
    init
  end
  
  def teardown
    Locator::Dom.adapter = @old_adapter
  end
end

