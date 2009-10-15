require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class NokogiriLocatorAreaTest < NokogiriLocatorTest
  def test_locates_the_first_element_when_no_value_given
    dom = dom('<area id="foo-bar" /><area id="foo" />')
    element = Locators::Area.new(dom).locate
    assert_equal 'foo-bar', element.attribute('id')
  end
  
  def test_locates_the_element_with_the_shortest_matching_id_attribute
    dom = dom('<area id="foo-bar" /><area id="foo" />')
    element = Locators::Area.new(dom, 'foo').locate
    assert_equal 'foo', element.attribute('id')
  end
  
  def test_locates_the_element_with_the_shortest_matching_title_attribute
    dom = dom('<area title="foo-bar" /><area title="foo" />')
    element = Locators::Area.new(dom, 'foo').locate
    assert_equal 'foo', element.attribute('title')
  end
  
  def test_locates_the_element_with_the_shortest_matching_alt_attribute
    dom = dom('<area alt="foo-bar" /><area alt="foo" />')
    element = Locators::Area.new(dom, 'foo').locate
    assert_equal 'foo', element.attribute('alt')
  end
  
  def test_returns_nil_for_a_non_existing_id
    dom = dom('<area id="foo" />')
    assert_nil Locators::Area.new(dom, 'bogus').locate
  end
  
  def test_returns_nil_for_a_non_existing_title
    dom = dom('<area title="foo" />')
    assert_nil Locators::Area.new(dom, 'bogus').locate
  end
  
  def test_returns_nil_for_a_non_existing_text
    dom = dom('<area>foo</area>')
    assert_nil Locators::Area.new(dom, 'bogus').locate
  end
end
