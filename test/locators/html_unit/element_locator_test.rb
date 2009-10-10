require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class ElementLocatorTest < Test::Unit::TestCase
  include Steam
  include Steam::Locators::HtmlUnit
  include TestHelper
  
  def test_locates_the_first_element_matching_the_node_type_given_as_a_symbol
    page = page('<p class="class" foo="bar"></p><p class="class" foo="baz"></p>')
    element = ElementLocator.new(page, :class => 'class', :'foo' => "baz").locate
    assert_equal 'baz', element.getAttribute('foo')
  end
  
  # def test_locates_the_first_element_matching_the_node_type_given_as_a_symbol
  #   page = page('<html><head></head><body><p class="foo-bar"></p><p class="foo"></p></html>')
  #   element = ElementLocator.new(page, :p).locate
  #   assert_equal 'foo-bar', element.getClassAttribute
  # end
  # 
  # def test_locates_the_first_element_matching_the_given_class
  #   page = page('<html><head></head><body><p class="foo-bar"></p><p class="foo"></p></html>')
  #   element = ElementLocator.new(page, :class => 'foo').locate
  #   assert_equal 'foo', element.getClassAttribute
  # end
  # 
  # def test_locates_the_first_element_matching_the_given_attributes
  #   page = page('<html><head></head><body><p class="foo-bar"></p><p class="foo" data-foo="bar"></p></html>')
  #   element = ElementLocator.new(page, :class => 'foo', :'data-foo' => 'bar').locate
  #   assert_equal 'bar', element.getAttribute('data-foo')
  # end
  # 
  # def test_locates_the_first_element_when_no_value_given
  #   page = page('<html><head></head><body><p id="foo-bar"></p><p id="foo"></p></html>')
  #   element = ElementLocator.new(page).locate
  #   assert_match %r(<html>), element.asXml
  # end
  # 
  # def test_locates_the_element_with_the_shortest_matching_id_attribute
  #   page = page('<html><head></head><body><p id="foo-bar"></p><p id="foo"></p></html>')
  #   element = ElementLocator.new(page, 'foo').locate
  #   assert_equal 'foo', element.getIdAttribute
  # end
  # 
  # def test_locates_the_element_with_the_shortest_matching_title_attribute
  #   page = page('<html><head></head><body><p title="foo-bar"></p><p title="foo"></p></html>')
  #   element = ElementLocator.new(page, 'foo').locate
  #   assert_equal 'foo', element.getTitleAttribute
  # end
  # 
  # def test_locates_the_element_with_the_shortest_matching_text_value
  #   page = page('<html><head></head><body><p>foo-bar</p><p>foo</p></html>')
  #   element = ElementLocator.new(page, 'foo').locate
  #   assert_equal 'foo', element.getTextContent
  # end
  # 
  # def test_returns_nil_for_a_non_existing_id
  #   page = page('<p id="foo"></p>')
  #   assert_nil ElementLocator.new(page, 'bogus').locate
  # end
  # 
  # def test_returns_nil_for_a_non_existing_title
  #   page = page('<p title="foo"></p>')
  #   assert_nil ElementLocator.new(page, 'bogus').locate
  # end
  # 
  # def test_returns_nil_for_a_non_existing_text
  #   page = page('<p>foo</p>')
  #   assert_nil ElementLocator.new(page, 'bogus').locate
  # end
end
