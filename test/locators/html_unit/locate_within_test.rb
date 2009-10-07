require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class LocateWithinTest < Test::Unit::TestCase
  include Steam
  include Steam::Locators::HtmlUnit
  include TestHelper
  
  def page(html = nil)
    html ? super : @page # hrmmm
  end

  def test_locates_the_element_within_the_given_scope
    @page = page('<html><body><form name="foo"></form><div id="div"><div><form name="bar"></form></div></div>')
    form = within(:div) { find_form }
    assert_equal 'bar', form.getNameAttribute
  end

  def test_finders_evaluate_blocks_within_the_resulting_element
    @page = page('<html><body><form name="foo"></form><div><div><form name="bar"></form></div></div>')
    form = find_element(:div) { find_element(:form) }
    assert_equal 'bar', form.getNameAttribute
  end
end