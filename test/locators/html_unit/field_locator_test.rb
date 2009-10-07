require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class FieldLocatorTest < Test::Unit::TestCase
  include Steam
  include Steam::Locators::HtmlUnit
  include TestHelper

  def test_locates_the_first_element_when_no_value_given
    page = page('<input type="text" name="foo-bar" /><input type="text" name="foo" />')
    element = FieldLocator.new(page).locate
    assert_equal 'foo-bar', element.getNameAttribute
  end
  
  def test_locates_the_element_with_the_shortest_matching_id_attribute
    page = page('<input type="text" id="foo-bar" /><input type="text" id="foo" />')
    element = FieldLocator.new(page, 'foo').locate
    assert_equal 'foo', element.getIdAttribute
  end
  
  def test_locates_the_element_with_the_shortest_matching_name_attribute
    page = page('<input type="text" name="foo-bar" /><input type="text" name="foo" />')
    element = FieldLocator.new(page, 'foo').locate
    assert_equal 'foo', element.getNameAttribute
  end
  
  def test_locates_the_element_with_the_shortest_matching_title_attribute
    page = page('<input type="text" title="foo-bar" /><input type="text" title="foo" />')
    element = FieldLocator.new(page, 'foo').locate
    assert_equal 'foo', element.getTitleAttribute
  end
  
  def test_locates_the_labeled_element_with_the_shortest_matching_label_text
    html = '<label for="1">foo-bar</label><input type="text" id="1" />' +
           '<label for="2">foo</label><input type="text" id="2" />'
    element = FieldLocator.new(page(html), 'foo').locate
    assert_equal '2', element.getIdAttribute
  end
  
  def test_locates_the_labeled_element_with_the_shortest_matching_label_id
    html = '<label id="foo-bar" for="1">bar-baz</label><input type="text" id="1" />' +
           '<label id="foo" for="2">bar-baz-buz</label><input type="text" id="2" />'
    element = FieldLocator.new(page(html), 'foo').locate
    assert_equal '2', element.getIdAttribute
  end
  
  def test_locates_the_labeled_element_when_text_is_shorter
    html = '<label for="foo-bar">bar</label><input type="text" id="foo-bar" />' +
           '<label for="2">foo</label><input type="text" id="2" />'
    element = FieldLocator.new(page(html), 'foo').locate
    assert_equal '2', element.getIdAttribute
  end
  
  def test_locates_the_labeled_element_when_id_is_shorter
    html = '<label id="bar" for="foo-bar">bar</label><input type="text" id="foo-bar" />' +
           '<label id="foo" for="2"></label><input type="text" id="2" />'
    element = FieldLocator.new(page(html), 'foo').locate
    assert_equal '2', element.getIdAttribute
  end
  
  def test_locates_the_element_by_id_when_id_is_shorter
    html = '<label for="bar">foo</label><input type="text" id="bar" />' +
           '<label for="foo"></label><input type="text" id="foo" />'
    element = FieldLocator.new(page(html), 'foo').locate
    assert_equal 'foo', element.getIdAttribute
  end
  
  def test_returns_nil_for_a_non_existing_id
    page = page('<input type="text" id="foo" />')
    assert_nil FieldLocator.new(page, 'bogus').locate
  end
  
  def test_returns_nil_for_a_non_existing_name
    page = page('<input type="text" name="foo" />')
    assert_nil FieldLocator.new(page, 'bogus').locate
  end
  
  def test_returns_nil_for_a_non_existing_title
    page = page('<input type="text" title="foo" />')
    assert_nil FieldLocator.new(page, 'bogus').locate
  end
end