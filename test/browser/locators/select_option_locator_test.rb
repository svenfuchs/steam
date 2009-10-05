require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class SelectOptionLocatorTest < Test::Unit::TestCase
  include Steam
  include Steam::Locators::HtmlUnit
  include TestHelper

  def test_locates_the_first_element_when_no_value_given
    page = page('<select><option id="foo-bar"></option><option id="foo"></option></select>')
    element = SelectOptionLocator.new(page).locate
    assert_equal 'foo-bar', element.getIdAttribute
  end

  def test_locates_the_element_with_the_shortest_matching_id_attribute
    page = page('<select><option id="foo-bar"></option><option id="foo"></option></select>')
    element = SelectOptionLocator.new(page).locate('foo')
    assert_equal 'foo', element.getIdAttribute
  end
  
  def test_locates_the_element_with_the_shortest_matching_value_attribute
    page = page('<select><option value="foo-bar"></option><option value="foo"></option></select>')
    element = SelectOptionLocator.new(page).locate('foo')
    assert_equal 'foo', element.getValueAttribute
  end
  
  def test_locates_the_element_with_the_shortest_matching_text
    page = page('<select><option>foo-bar</option><option>foo</option></select>')
    element = SelectOptionLocator.new(page).locate('foo')
    assert_equal 'foo', element.getTextContent
  end
  
  def test_returns_nil_for_a_non_existing_id
    page = page('<select><option id="foo"></option></select>')
    assert_nil SelectOptionLocator.new(page).locate('bogus')
  end
  
  def test_returns_nil_for_a_non_existing_name
    page = page('<select><option name="foo"></option></select>')
    assert_nil SelectOptionLocator.new(page).locate('bogus')
  end
  
  def test_returns_nil_for_a_non_existing_title
    page = page('<select><option title="foo"></option></select>')
    assert_nil SelectOptionLocator.new(page).locate('bogus')
  end
end

