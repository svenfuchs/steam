require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class LabelLocatorTest < Test::Unit::TestCase
  include Steam
  include Steam::Locators::HtmlUnit
  include TestHelper

  def test_locates_the_first_element_when_no_value_given
    page = page('<label id="foo-bar"></label><label id="foo"></label>')
    element = LabelLocator.new(page).locate
    assert_equal 'foo-bar', element.getIdAttribute
  end
  
  def test_locates_the_element_with_the_shortest_matching_id_attribute
    page = page('<label id="foo-bar"></label><label id="foo"></label>')
    element = LabelLocator.new(page, 'foo').locate
    assert_equal 'foo', element.getIdAttribute
  end
  
  def test_locates_the_element_with_the_shortest_matching_title_attribute
    page = page('<label title="foo-bar"></label><label title="foo"></label>')
    element = LabelLocator.new(page, 'foo').locate
    assert_equal 'foo', element.getTitleAttribute
  end
  
  def test_locates_the_element_with_the_shortest_matching_text_value
    page = page('<label>foo-bar</label><label>foo</label>')
    element = LabelLocator.new(page, 'foo').locate
    assert_equal 'foo', element.getTextContent
  end
  
  def test_returns_nil_for_a_non_existing_id
    page = page('<label id="foo"></label>')
    assert_nil LabelLocator.new(page, 'bogus').locate
  end
  
  def test_returns_nil_for_a_non_existing_title
    page = page('<label title="foo"></label>')
    assert_nil LabelLocator.new(page, 'bogus').locate
  end

  def test_returns_nil_for_a_non_existing_text
    page = page('<label>foo</label>')
    assert_nil LabelLocator.new(page, 'bogus').locate
  end
end
