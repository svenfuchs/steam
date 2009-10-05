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
    form = within('div') do
      find_form
    end
    assert_equal 'bar', form.getNameAttribute
  end
end