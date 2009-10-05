require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class TextAreaLocatorTest < Test::Unit::TestCase
  include Steam
  include Steam::Locators::HtmlUnit
  include TestHelper

  def test_locates_the_first_element_when_no_value_given
    page = page('<textarea name="foo-bar"></textarea><textarea name="foo"></textarea>')
    element = TextAreaLocator.new(page).locate
    assert_equal 'foo-bar', element.getNameAttribute
  end

  def test_locates_the_element_with_the_shortest_matching_id_attribute
    page = page('<textarea id="foo-bar"></textarea><textarea id="foo"></textarea>')
    element = TextAreaLocator.new(page).locate('foo')
    assert_equal 'foo', element.getIdAttribute
  end

  def test_locates_the_element_with_the_shortest_matching_name_attribute
    page = page('<textarea name="foo-bar"></textarea><textarea name="foo"></textarea>')
    element = TextAreaLocator.new(page).locate('foo')
    assert_equal 'foo', element.getNameAttribute
  end

  def test_locates_the_element_with_the_shortest_matching_title_attribute
    page = page('<textarea title="foo-bar"></textarea><textarea title="foo"></textarea>')
    element = TextAreaLocator.new(page).locate('foo')
    assert_equal 'foo', element.getTitleAttribute
  end
  
  def test_returns_nil_for_a_non_existing_id
    page = page('<textarea id="foo"></textarea>')
    assert_nil TextAreaLocator.new(page).locate('bogus')
  end

  def test_returns_nil_for_a_non_existing_name
    page = page('<textarea name="foo"></textarea>')
    assert_nil TextAreaLocator.new(page).locate('bogus')
  end
  
  def test_returns_nil_for_a_non_existing_title
    page = page('<textarea title="foo"></textarea>')
    assert_nil TextAreaLocator.new(page).locate('bogus')
  end
end

