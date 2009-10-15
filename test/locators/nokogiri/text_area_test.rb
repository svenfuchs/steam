require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class NokogiriLocatorTextAreaTest < NokogiriLocatorTest

  def test_locates_the_first_element_when_no_value_given
    dom = dom('<textarea name="foo-bar"></textarea><textarea name="foo"></textarea>')
    element = Locators::TextArea.new(dom).locate
    assert_equal 'foo-bar', element.attribute('name')
  end

  def test_locates_the_element_with_the_shortest_matching_id_attribute
    dom = dom('<textarea id="foo-bar"></textarea><textarea id="foo"></textarea>')
    element = Locators::TextArea.new(dom, 'foo').locate
    assert_equal 'foo', element.attribute('id')
  end

  def test_locates_the_element_with_the_shortest_matching_name_attribute
    dom = dom('<textarea name="foo-bar"></textarea><textarea name="foo"></textarea>')
    element = Locators::TextArea.new(dom, 'foo').locate
    assert_equal 'foo', element.attribute('name')
  end

  def test_locates_the_element_with_the_shortest_matching_title_attribute
    dom = dom('<textarea title="foo-bar"></textarea><textarea title="foo"></textarea>')
    element = Locators::TextArea.new(dom, 'foo').locate
    assert_equal 'foo', element.attribute('title')
  end
  
  def test_returns_nil_for_a_non_existing_id
    dom = dom('<textarea id="foo"></textarea>')
    assert_nil Locators::TextArea.new(dom, 'bogus').locate
  end

  def test_returns_nil_for_a_non_existing_name
    dom = dom('<textarea name="foo"></textarea>')
    assert_nil Locators::TextArea.new(dom, 'bogus').locate
  end
  
  def test_returns_nil_for_a_non_existing_title
    dom = dom('<textarea title="foo"></textarea>')
    assert_nil Locators::TextArea.new(dom, 'bogus').locate
  end
end

