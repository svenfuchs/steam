require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class NokogiriLocatorSelectOptionTest < NokogiriLocatorTest

  def test_locates_the_first_element_when_no_value_given
    dom = dom('<select><option id="foo-bar"></option><option id="foo"></option></select>')
    element = Locators::SelectOption.new(dom).locate
    assert_equal 'foo-bar', element.attribute('id')
  end

  def test_locates_the_element_with_the_shortest_matching_id_attribute
    dom = dom('<select><option id="foo-bar"></option><option id="foo"></option></select>')
    element = Locators::SelectOption.new(dom, 'foo').locate
    assert_equal 'foo', element.attribute('id')
  end
  
  def test_locates_the_element_with_the_shortest_matching_value_attribute
    dom = dom('<select><option value="foo-bar"></option><option value="foo"></option></select>')
    element = Locators::SelectOption.new(dom, 'foo').locate
    assert_equal 'foo', element.attribute('value')
  end
  
  def test_locates_the_element_with_the_shortest_matching_text
    dom = dom('<select><option>foo-bar</option><option>foo</option></select>')
    element = Locators::SelectOption.new(dom, 'foo').locate
    assert_equal 'foo', element.inner_html
  end
  
  def test_returns_nil_for_a_non_existing_id
    dom = dom('<select><option id="foo"></option></select>')
    assert_nil Locators::SelectOption.new(dom, 'bogus').locate
  end
  
  def test_returns_nil_for_a_non_existing_name
    dom = dom('<select><option name="foo"></option></select>')
    assert_nil Locators::SelectOption.new(dom, 'bogus').locate
  end
  
  def test_returns_nil_for_a_non_existing_title
    dom = dom('<select><option title="foo"></option></select>')
    assert_nil Locators::SelectOption.new(dom, 'bogus').locate
  end
end

