require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class AreaLocatorTest < Test::Unit::TestCase
  include Steam
  include Steam::Locators::HtmlUnit
  include TestHelper

  def test_locates_the_first_element_when_no_value_given
    page = page('<area id="foo-bar" /><area id="foo" />')
    element = AreaLocator.new(page).locate
    assert_equal 'foo-bar', element.getIdAttribute
  end
  
  def test_locates_the_element_with_the_shortest_matching_id_attribute
    page = page('<area id="foo-bar" /><area id="foo" />')
    element = AreaLocator.new(page).locate('foo')
    assert_equal 'foo', element.getIdAttribute
  end
  
  def test_locates_the_element_with_the_shortest_matching_title_attribute
    page = page('<area title="foo-bar" /><area title="foo" />')
    element = AreaLocator.new(page).locate('foo')
    assert_equal 'foo', element.getTitleAttribute
  end
  
  def test_locates_the_element_with_the_shortest_matching_alt_attribute
    page = page('<area alt="foo-bar" /><area alt="foo" />')
    element = AreaLocator.new(page).locate('foo')
    assert_equal 'foo', element.getAltAttribute
  end
  
  def test_returns_nil_for_a_non_existing_id
    page = page('<area id="foo" />')
    assert_nil AreaLocator.new(page).locate('bogus')
  end
  
  def test_returns_nil_for_a_non_existing_title
    page = page('<area title="foo" />')
    assert_nil AreaLocator.new(page).locate('bogus')
  end
  
  def test_returns_nil_for_a_non_existing_text
    page = page('<area>foo</area>')
    assert_nil AreaLocator.new(page).locate('bogus')
  end
end
