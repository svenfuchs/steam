require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class LinkLocatorTest < Test::Unit::TestCase
  include Steam
  include Steam::Locators::HtmlUnit
  include TestHelper

  def test_locates_the_first_element_when_no_value_given
    page = page('<a id="foo-bar" /><a id="foo" />')
    element = LinkLocator.new(page).locate
    assert_equal 'foo-bar', element.getIdAttribute
  end
  
  def test_locates_the_element_with_the_shortest_matching_id_attribute
    page = page('<a id="foo-bar" /><a id="foo" />')
    element = LinkLocator.new(page, 'foo').locate
    assert_equal 'foo', element.getIdAttribute
  end
  
  def test_locates_the_element_with_the_shortest_matching_title_attribute
    page = page('<a title="foo-bar" /><a title="foo" />')
    element = LinkLocator.new(page, 'foo').locate
    assert_equal 'foo', element.getTitleAttribute
  end
  
  def test_locates_the_element_with_the_shortest_matching_text_value
    page = page('<a>foo-bar</a><a>foo</a>')
    element = LinkLocator.new(page, 'foo').locate
    assert_equal 'foo', element.getTextContent
  end
  
  def test_returns_nil_for_a_non_existing_id
    page = page('<a id="foo" />')
    assert_nil LinkLocator.new(page, 'bogus').locate
  end
  
  def test_returns_nil_for_a_non_existing_title
    page = page('<a title="foo" />')
    assert_nil LinkLocator.new(page, 'bogus').locate
  end

  def test_returns_nil_for_a_non_existing_text
    page = page('<a>foo</a>')
    assert_nil LinkLocator.new(page, 'bogus').locate
  end
end
