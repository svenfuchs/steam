require File.expand_path(File.dirname(__FILE__) + '/../../../test_helper')

class HtmlUnitButtonLocatorInputImageTest < HtmlUnitLocatorTest

  def test_locates_the_first_element_when_no_value_given
    dom = dom('<input type="image" name="foo-bar" /><input type="image" name="foo" />')
    element = Button.new(dom).locate
    assert_equal 'foo-bar', element.attribute('name')
  end

  def test_locates_the_element_with_the_shortest_matching_id_attribute
    dom = dom('<input type="image" id="foo-bar" /><input type="image" id="foo" />')
    element = Button.new(dom, 'foo').locate
    assert_equal 'foo', element.attribute('id')
  end
  
  def test_locates_the_element_with_the_shortest_matching_name_attribute
    dom = dom('<input type="image" name="foo-bar" /><input type="image" name="foo" />')
    element = Button.new(dom, 'foo').locate
    assert_equal 'foo', element.attribute('name')
  end
  
  def test_locates_the_element_with_the_shortest_matching_title_attribute
    dom = dom('<input type="image" title="foo-bar" /><input type="image" title="foo" />')
    element = Button.new(dom, 'foo').locate
    assert_equal 'foo', element.attribute('title')
  end
  
  def test_locates_the_element_with_the_shortest_matching_alt_attribute
    dom = dom('<input type="image" alt="foo-bar" /><input type="image" alt="foo" />')
    element = Button.new(dom, 'foo').locate
    assert_equal 'foo', element.attribute('alt')
  end
  
  def test_returns_nil_for_a_non_existing_id
    dom = dom('<input type="image" id="foo" />')
    assert_nil Button.new(dom, 'bogus').locate
  end
  
  def test_returns_nil_for_a_non_existing_name
    dom = dom('<input type="image" name="foo" />')
    assert_nil Button.new(dom, 'bogus').locate
  end
  
  def test_returns_nil_for_a_non_existing_title
    dom = dom('<input type="image" title="foo" />')
    assert_nil Button.new(dom, 'bogus').locate
  end
end