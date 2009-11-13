require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class LocateWithinTest < HtmlUnitLocatorTest
  def test_locates_the_element_within_the_given_scope
    @page = dom('<html><body><form name="foo"></form><div id="div"><div><form name="bar"></form></div></div>')
    form = within(:div) { locate_form() }
    assert_equal 'bar', form.attribute('name')
  end

  def test_finders_evaluate_blocks_within_the_resulting_element
    @page = dom('<html><body><form name="foo"></form><div><div><form name="bar"></form></div></div>')
    form = locate_element(:div) { locate_element(:form) }
    assert_equal 'bar', form.attribute('name')
  end
end