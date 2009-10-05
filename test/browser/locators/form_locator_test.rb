require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class FormLocatorTest < Test::Unit::TestCase
  include Steam
  include Steam::Locators::HtmlUnit
  include TestHelper

  def test_locates_the_first_form_when_no_value_given
    page = page('<form name="foo"></form><form name="bar"></form>')
    form = FormLocator.new(page).locate
    assert_equal 'foo', form.getNameAttribute
  end

  def test_locates_the_element_with_the_shortest_matching_value
    page = page('<form name="foo-bar-baz"></form><form name="foo-bar"></form>')
    form = FormLocator.new(page).locate('foo')
    assert_equal 'foo-bar', form.getNameAttribute
  end

  def test_locates_a_form_by_name
    page = page('<form name="foo"></form>')
    assert FormLocator.new(page).locate('foo')
  end

  def test_locates_a_form_by_id
    page = page('<form id="foo"></form>')
    assert FormLocator.new(page).locate('foo')
  end

  def test_returns_nil_for_a_non_existing_name
    page = page('<form name="foo"></form>')
    assert_nil FormLocator.new(page).locate('bogus')
  end

  def test_returns_nil_for_a_non_existing_id
    page = page('<form id="foo"></form>')
    assert_nil FormLocator.new(page).locate('bogus')
  end
end