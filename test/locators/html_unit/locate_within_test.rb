require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class HtmlUnitLocateWithinTest < HtmlUnitLocatorTest
  def test_locates_the_element_within_the_given_scope
    @page = dom('<html><body><form name="foo"></form><div id="div"><div><form name="bar"></form></div></div>')
    form = within(:div, :using => :html_unit) { locate_form(:using => :html_unit) }
    assert_equal 'bar', form.attribute('name')
  end

  def test_finders_evaluate_blocks_within_the_resulting_element
    @page = dom('<html><body><form name="foo"></form><div><div><form name="bar"></form></div></div>')
    form = locate_element(:div, :using => :html_unit) { locate_element(:form, :using => :html_unit) }
    assert_equal 'bar', form.attribute('name')
  end
end