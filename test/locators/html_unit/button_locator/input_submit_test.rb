require File.expand_path(File.dirname(__FILE__) + '/../../../test_helper')

class HtmlUnitButtonLocatorInputSubmitTest < HtmlUnitLocatorTest

  def test_locates_the_first_element_when_no_value_given
    dom = dom('<input type="submit" name="foo-bar" /><input type="submit" name="foo" />')
    element = Button.new(dom).locate
    assert_equal 'foo-bar', element.attribute('name')
  end

  def test_locates_the_element_with_the_shortest_matching_id_attribute
    dom = dom('<input type="submit" id="foo-bar" /><input type="submit" id="foo" />')
    element = Button.new(dom, 'foo').locate
    assert_equal 'foo', element.attribute('id')
  end
  
  def test_locates_the_element_with_the_shortest_matching_name_attribute
    dom = dom('<input type="submit" name="foo-bar" /><input type="submit" name="foo" />')
    element = Button.new(dom, 'foo').locate
    assert_equal 'foo', element.attribute('name')
  end
  
  def test_locates_the_element_with_the_shortest_matching_title_attribute
    dom = dom('<input type="submit" title="foo-bar" /><input type="submit" title="foo" />')
    element = Button.new(dom, 'foo').locate
    assert_equal 'foo', element.attribute('title')
  end
  
  def test_locates_the_element_with_the_shortest_matching_value_attribute
    dom = dom('<input type="submit" value="foo-bar" /><input type="submit" value="foo" />')
    element = Button.new(dom, 'foo').locate
    assert_equal 'foo', element.attribute('value')
  end
  
  def test_returns_nil_for_a_non_existing_id
    dom = dom('<input type="submit" id="foo" />')
    assert_nil Button.new(dom, 'bogus').locate
  end
  
  def test_returns_nil_for_a_non_existing_name
    dom = dom('<input type="submit" name="foo" />')
    assert_nil Button.new(dom, 'bogus').locate
  end
  
  def test_returns_nil_for_a_non_existing_title
    dom = dom('<input type="submit" title="foo" />')
    assert_nil Button.new(dom, 'bogus').locate
  end
end