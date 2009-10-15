require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class NokogiriLocatorFieldTest < NokogiriLocatorTest

  def test_locates_the_first_element_when_no_value_given
    dom = dom('<input type="text" name="foo-bar" /><input type="text" name="foo" />')
    element = Locators::Field.new(dom).locate
    assert_equal 'foo-bar', element.attribute('name')
  end
  
  def test_locates_the_element_with_the_shortest_matching_id_attribute
    dom = dom('<input type="text" id="foo-bar" /><input type="text" id="foo" />')
    element = Locators::Field.new(dom, 'foo').locate
    assert_equal 'foo', element.attribute('id')
  end
  
  def test_locates_the_element_with_the_shortest_matching_name_attribute
    dom = dom('<input type="text" name="foo-bar" /><input type="text" name="foo" />')
    element = Locators::Field.new(dom, 'foo').locate
    assert_equal 'foo', element.attribute('name')
  end
  
  def test_locates_the_element_with_the_shortest_matching_title_attribute
    dom = dom('<input type="text" title="foo-bar" /><input type="text" title="foo" />')
    element = Locators::Field.new(dom, 'foo').locate
    assert_equal 'foo', element.attribute('title')
  end
  
  def test_locates_the_labeled_element_with_the_shortest_matching_label_text
    html = '<label for="1">foo-bar</label><input type="text" id="1" />' +
           '<label for="2">foo</label><input type="text" id="2" />'
    element = Locators::Field.new(dom(html), 'foo').locate
    assert_equal '2', element.attribute('id')
  end
  
  def test_locates_the_labeled_element_with_the_shortest_matching_label_id
    html = '<label id="foo-bar" for="1">bar-baz</label><input type="text" id="1" />' +
           '<label id="foo" for="2">bar-baz-buz</label><input type="text" id="2" />'
    element = Locators::Field.new(dom(html), 'foo').locate
    assert_equal '2', element.attribute('id')
  end
  
  def test_locates_the_labeled_element_when_text_is_shorter
    html = '<label for="foo-bar">bar</label><input type="text" id="foo-bar" />' +
           '<label for="2">foo</label><input type="text" id="2" />'
    element = Locators::Field.new(dom(html), 'foo').locate
    assert_equal '2', element.attribute('id')
  end
  
  def test_locates_the_labeled_element_when_id_is_shorter
    html = '<label id="bar" for="foo-bar">bar</label><input type="text" id="foo-bar" />' +
           '<label id="foo" for="2"></label><input type="text" id="2" />'
    element = Locators::Field.new(dom(html), 'foo').locate
    assert_equal '2', element.attribute('id')
  end
  
  def test_locates_the_element_by_id_when_id_is_shorter
    html = '<label for="bar">foo</label><input type="text" id="bar" />' +
           '<label for="foo"></label><input type="text" id="foo" />'
    element = Locators::Field.new(dom(html), 'foo').locate
    assert_equal 'foo', element.attribute('id')
  end
  
  def test_returns_nil_for_a_non_existing_id
    dom = dom('<input type="text" id="foo" />')
    assert_nil Locators::Field.new(dom, 'bogus').locate
  end
  
  def test_returns_nil_for_a_non_existing_name
    dom = dom('<input type="text" name="foo" />')
    assert_nil Locators::Field.new(dom, 'bogus').locate
  end
  
  def test_returns_nil_for_a_non_existing_title
    dom = dom('<input type="text" title="foo" />')
    assert_nil Locators::Field.new(dom, 'bogus').locate
  end
end