require File.expand_path(File.dirname(__FILE__) + '/../../../test_helper')

class ButtonLocatorInputSubmitTest < Test::Unit::TestCase
  include Steam
  include Steam::Locators::HtmlUnit
  include TestHelper

  def test_locates_the_first_element_when_no_value_given
    page = page('<input type="submit" name="foo-bar" /><input type="submit" name="foo" />')
    element = ButtonLocator.new(page).locate
    assert_equal 'foo-bar', element.getNameAttribute
  end

  def test_locates_the_element_with_the_shortest_matching_id_attribute
    page = page('<input type="submit" id="foo-bar" /><input type="submit" id="foo" />')
    element = ButtonLocator.new(page, 'foo').locate
    assert_equal 'foo', element.getIdAttribute
  end
  
  def test_locates_the_element_with_the_shortest_matching_name_attribute
    page = page('<input type="submit" name="foo-bar" /><input type="submit" name="foo" />')
    element = ButtonLocator.new(page, 'foo').locate
    assert_equal 'foo', element.getNameAttribute
  end
  
  def test_locates_the_element_with_the_shortest_matching_title_attribute
    page = page('<input type="submit" title="foo-bar" /><input type="submit" title="foo" />')
    element = ButtonLocator.new(page, 'foo').locate
    assert_equal 'foo', element.getTitleAttribute
  end
  
  def test_locates_the_element_with_the_shortest_matching_value_attribute
    page = page('<input type="submit" value="foo-bar" /><input type="submit" value="foo" />')
    element = ButtonLocator.new(page, 'foo').locate
    assert_equal 'foo', element.getValueAttribute
  end
  
  def test_returns_nil_for_a_non_existing_id
    page = page('<input type="submit" id="foo" />')
    assert_nil ButtonLocator.new(page, 'bogus').locate
  end
  
  def test_returns_nil_for_a_non_existing_name
    page = page('<input type="submit" name="foo" />')
    assert_nil ButtonLocator.new(page, 'bogus').locate
  end
  
  def test_returns_nil_for_a_non_existing_title
    page = page('<input type="submit" title="foo" />')
    assert_nil ButtonLocator.new(page, 'bogus').locate
  end
end