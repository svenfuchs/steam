require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class NokogiriLocatorElementTest < NokogiriLocatorTest
  def test_locate
    html = '<p></p>'
    @page = dom(html)
    element = locate(:element, :p)
    assert_equal html, element.to_s
  end

  def test_locates_the_first_element_matching_all_given_attributes
    dom = dom('<p class="class" foo="bar"></p><p class="class" foo="baz"></p>')
    element = Locators::Element.new(dom, :class => 'class', :'foo' => "baz").locate
    assert_equal 'baz', element.attribute('foo').to_s
  end

  def test_locates_the_first_element_matching_the_node_type_given_as_a_symbol
    dom = dom('<html><head></head><body><p class="foo-bar"></p><p class="foo"></p></html>')
    element = Locators::Element.new(dom, :p).locate
    assert_equal 'foo-bar', element.attribute('class').to_s
  end

  def test_locates_the_first_element_matching_the_given_class
    dom = dom('<html><head></head><body><p class="bar-baz"></p><p class="foo"></p></html>')
    element = Locators::Element.new(dom, :class => 'foo').locate
    assert_equal 'foo', element.attribute('class').to_s
  end

  def test_locates_the_first_element_matching_the_given_attributes
    dom = dom('<html><head></head><body><p class="foo-bar"></p><p class="foo" data-foo="bar"></p></html>')
    element = Locators::Element.new(dom, :class => 'foo', :'data-foo' => 'bar').locate
    assert_equal 'bar', element.attribute('data-foo').to_s
  end

  def test_locates_the_first_element_when_no_value_given
    dom = dom('<html><head></head><body><p id="foo-bar"></p><p id="foo"></p></html>')
    element = Locators::Element.new(dom).locate
    assert_match %r(<html>), element.to_s
  end

  def test_locates_the_element_with_the_shortest_matching_id_attribute
    dom = dom('<html><head></head><body><p id="foo-bar"></p><p id="foo"></p></html>')
    element = Locators::Element.new(dom, 'foo').locate
    assert_equal 'foo', element.attribute('id').to_s
  end

  def test_locates_the_element_with_the_shortest_matching_title_attribute
    dom = dom('<html><head></head><body><p title="foo-bar"></p><p title="foo"></p></html>')
    element = Locators::Element.new(dom, 'foo').locate
    assert_equal 'foo', element.attribute('title').to_s
  end

  def test_locates_the_element_with_the_shortest_matching_text_value
    dom = dom('<html><head></head><body><p>foo-bar</p><p>foo</p></html>')
    element = Locators::Element.new(dom, 'foo').locate
    assert_equal 'foo', element.inner_html
  end

  def test_returns_nil_for_a_non_existing_id
    dom = dom('<p id="foo"></p>')
    assert_nil Locators::Element.new(dom, 'bogus').locate
  end

  def test_returns_nil_for_a_non_existing_title
    dom = dom('<p title="foo"></p>')
    assert_nil Locators::Element.new(dom, 'bogus').locate
  end

  def test_returns_nil_for_a_non_existing_text
    dom = dom('<p>foo</p>')
    assert_nil Locators::Element.new(dom, 'bogus').locate
  end
end
