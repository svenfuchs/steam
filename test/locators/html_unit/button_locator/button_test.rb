require File.expand_path(File.dirname(__FILE__) + '/../../../test_helper')

class ButtonLocatorButtonTest < Test::Unit::TestCase
  include Steam
  include Steam::Locators::HtmlUnit
  include TestHelper

  def test_locates_the_first_element_when_no_value_given
    page = page('<button name="foo-bar" /><button name="foo" />')
    element = ButtonLocator.new(page).locate
    assert_equal 'foo-bar', element.getNameAttribute
  end
  
  def test_locates_the_element_with_the_shortest_matching_id_attribute
    page = page('<button id="foo-bar" /><button id="foo" />')
    element = ButtonLocator.new(page, 'foo').locate
    assert_equal 'foo', element.getIdAttribute
  end
  
  def test_locates_the_element_with_the_shortest_matching_name_attribute
    page = page('<button name="foo-bar" /><button name="foo" />')
    element = ButtonLocator.new(page, 'foo').locate
    assert_equal 'foo', element.getNameAttribute
  end
  
  def test_locates_the_element_with_the_shortest_matching_title_attribute
    page = page('<button title="foo-bar" /><button title="foo" />')
    element = ButtonLocator.new(page, 'foo').locate
    assert_equal 'foo', element.getTitleAttribute
  end
  
  def test_locates_the_element_with_the_shortest_matching_inner_text_value
    page = page('<button>foo-bar</button><button>foo</button>')
    element = ButtonLocator.new(page, 'foo').locate
    assert_equal 'foo', element.getTextContent
  end
  
  def test_returns_nil_for_a_non_existing_id
    page = page('<button id="foo" />')
    assert_nil ButtonLocator.new(page, 'bogus').locate
  end
  
  def test_returns_nil_for_a_non_existing_name
    page = page('<button name="foo" />')
    assert_nil ButtonLocator.new(page, 'bogus').locate
  end
  
  def test_returns_nil_for_a_non_existing_title
    page = page('<button title="foo" />')
    assert_nil ButtonLocator.new(page, 'bogus').locate
  end
end
