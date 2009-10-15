require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class NokogiriLocatorFormTest < NokogiriLocatorTest

  def test_locates_the_first_form_when_no_value_given
    dom = dom('<form name="foo"></form><form name="bar"></form>')
    form = Locators::Form.new(dom).locate
    assert_equal 'foo', form.attribute('name')
  end

  def test_locates_the_element_with_the_shortest_matching_value
    dom = dom('<form name="foo-bar-baz"></form><form name="foo-bar"></form>')
    form = Locators::Form.new(dom, 'foo').locate
    assert_equal 'foo-bar', form.attribute('name')
  end

  def test_locates_a_form_by_name
    dom = dom('<form name="foo"></form>')
    assert Locators::Form.new(dom, 'foo').locate
  end

  def test_locates_a_form_by_id
    dom = dom('<form id="foo"></form>')
    assert Locators::Form.new(dom, 'foo').locate
  end

  def test_returns_nil_for_a_non_existing_name
    dom = dom('<form name="foo"></form>')
    assert_nil Locators::Form.new(dom, 'bogus').locate
  end

  def test_returns_nil_for_a_non_existing_id
    dom = dom('<form id="foo"></form>')
    assert_nil Locators::Form.new(dom, 'bogus').locate
  end
end