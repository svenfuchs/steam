require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class NokogiriLocatorLabelTest < NokogiriLocatorTest

  def test_locates_the_first_element_when_no_value_given
    dom = dom('<label id="foo-bar"></label><label id="foo"></label>')
    element = Locators::Label.new(dom).locate
    assert_equal 'foo-bar', element.attribute('id')
  end
  
  def test_locates_the_element_with_the_shortest_matching_id_attribute
    dom = dom('<label id="foo-bar"></label><label id="foo"></label>')
    element = Locators::Label.new(dom, 'foo').locate
    assert_equal 'foo', element.attribute('id')
  end
  
  def test_locates_the_element_with_the_shortest_matching_title_attribute
    dom = dom('<label title="foo-bar"></label><label title="foo"></label>')
    element = Locators::Label.new(dom, 'foo').locate
    assert_equal 'foo', element.attribute('title')
  end
  
  def test_locates_the_element_with_the_shortest_matching_text_value
    dom = dom('<label>foo-bar</label><label>foo</label>')
    element = Locators::Label.new(dom, 'foo').locate
    assert_equal 'foo', element.inner_html
  end
  
  def test_returns_nil_for_a_non_existing_id
    dom = dom('<label id="foo"></label>')
    assert_nil Locators::Label.new(dom, 'bogus').locate
  end
  
  def test_returns_nil_for_a_non_existing_title
    dom = dom('<label title="foo"></label>')
    assert_nil Locators::Label.new(dom, 'bogus').locate
  end

  def test_returns_nil_for_a_non_existing_text
    dom = dom('<label>foo</label>')
    assert_nil Locators::Label.new(dom, 'bogus').locate
  end
end
