require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class NokogiriLocatorLinkTest < NokogiriLocatorTest
  def test_locate
    html = '<a href="http://example.com"></a>'
    @page = dom(html)
    element = locate(:link, :href => 'http://example.com')
    assert_equal html, element.to_s
  end
  
  # def test_locates_the_first_element_when_no_value_given
  #   dom = dom('<a id="foo-bar" /><a id="foo" />')
  #   element = Locators::Link.new(dom).locate
  #   assert_equal 'foo-bar', element.attribute('id').to_s
  # end
  # 
  # def test_locates_the_element_with_the_shortest_matching_id_attribute
  #   dom = dom('<a id="foo-bar" /><a id="foo" />')
  #   element = Locators::Link.new(dom, 'foo').locate
  #   assert_equal 'foo', element.attribute('id').to_s
  # end
  # 
  # def test_locates_the_element_with_the_shortest_matching_title_attribute
  #   dom = dom('<a title="foo-bar" /><a title="foo" />')
  #   element = Locators::Link.new(dom, 'foo').locate
  #   assert_equal 'foo', element.attribute('title').to_s
  # end
  # 
  # def test_locates_the_element_with_the_shortest_matching_text_value
  #   dom = dom('<a>foo-bar</a><a>foo</a>')
  #   element = Locators::Link.new(dom, 'foo').locate
  #   assert_equal 'foo', element.inner_html
  # end
  # 
  # def test_returns_nil_for_a_non_existing_id
  #   dom = dom('<a id="foo" />')
  #   assert_nil Locators::Link.new(dom, 'bogus').locate
  # end
  # 
  # def test_returns_nil_for_a_non_existing_title
  #   dom = dom('<a title="foo" />')
  #   assert_nil Locators::Link.new(dom, 'bogus').locate
  # end
  # 
  # def test_returns_nil_for_a_non_existing_text
  #   dom = dom('<a>foo</a>')
  #   assert_nil Locators::Link.new(dom, 'bogus').locate
  # end
end
