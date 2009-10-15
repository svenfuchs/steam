require File.expand_path(File.dirname(__FILE__) + '/../../../test_helper')

class HtmlUnitButtonLocatorButtonTest < HtmlUnitLocatorTest

  def test_locates_the_first_element_when_no_value_given
    dom = dom('<button name="foo-bar" /><button name="foo" />')
    element = Button.new(dom).locate
    assert_equal 'foo-bar', element.attribute('name')
  end
  
  def test_locates_the_element_with_the_shortest_matching_id_attribute
    dom = dom('<button id="foo-bar" /><button id="foo" />')
    element = Button.new(dom, 'foo').locate
    assert_equal 'foo', element.attribute('id')
  end
  
  def test_locates_the_element_with_the_shortest_matching_name_attribute
    dom = dom('<button name="foo-bar" /><button name="foo" />')
    element = Button.new(dom, 'foo').locate
    assert_equal 'foo', element.attribute('name')
  end
  
  def test_locates_the_element_with_the_shortest_matching_title_attribute
    dom = dom('<button title="foo-bar" /><button title="foo" />')
    element = Button.new(dom, 'foo').locate
    assert_equal 'foo', element.attribute('title')
  end
  
  def test_locates_the_element_with_the_shortest_matching_inner_text_value
    dom = dom('<button>foo-bar</button><button>foo</button>')
    element = Button.new(dom, 'foo').locate
    assert_equal 'foo', element.inner_html
  end
  
  def test_returns_nil_for_a_non_existing_id
    dom = dom('<button id="foo" />')
    assert_nil Button.new(dom, 'bogus').locate
  end
  
  def test_returns_nil_for_a_non_existing_name
    dom = dom('<button name="foo" />')
    assert_nil Button.new(dom, 'bogus').locate
  end
  
  def test_returns_nil_for_a_non_existing_title
    dom = dom('<button title="foo" />')
    assert_nil Button.new(dom, 'bogus').locate
  end
end
