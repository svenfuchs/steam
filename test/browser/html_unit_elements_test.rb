require File.expand_path(File.dirname(__FILE__) + '/../test_helper')
require 'erb'

class HtmlUnitElementsTest < Test::Unit::TestCase
  include Steam
  include TestHelper
  include HtmlUnitHelper

  def test_click_on_clicks_a_link
    perform :get, 'http://localhost:3000/', html

    element = @browser.locate_element('link')

    assert_response_contains('LINK') do
      @mock.mock :get, 'http://localhost:3000/link', 'LINK'
      @browser.click_on(element)
    end
  end

  def test_click_on_clicks_a_button
    perform :get, 'http://localhost:3000/', html(:field)

    element = @browser.locate_element('button')

    assert_response_contains('FORM') do
      @mock.mock :get, 'http://localhost:3000/form?field=', 'FORM'
      @browser.click_on(element)
    end
  end

  def test_click_link
    perform :get, 'http://localhost:3000/', html(:foo)

    element = @browser.locate_element('link')

    assert_response_contains('LINK') do
      @mock.mock :get, 'http://localhost:3000/link', 'LINK'
      @browser.click_link(element)
    end
  end

  def test_click_button
    perform :get, 'http://localhost:3000/', html(:field)

    element = @browser.locate_element('button')

    assert_response_contains('FORM') do
      @mock.mock :get, 'http://localhost:3000/form?field=', 'FORM'
      @browser.click_button(element)
    end
  end

  def test_submit_form
    perform :get, 'http://localhost:3000/', html(:field)

    element = @browser.locate_element('form')

    assert_response_contains('FORM') do
      @mock.mock :get, 'http://localhost:3000/form?field=', 'FORM'
      @browser.submit_form(element)
    end
  end

  def test_fill_in
    perform :get, 'http://localhost:3000/', html(:field)

    element = @browser.locate_element('field')

    assert_response_contains('FIELD') do
      @mock.mock :get, 'http://localhost:3000/form?field=field', 'FIELD'
      @browser.fill_in(element, :with => 'field')
      @browser.submit_form('form')
    end
  end

  def test_fill_in_textarea
    perform :get, 'http://localhost:3000/', html(:textarea)

    element = @browser.locate_element('textarea')

    assert_response_contains('TEXTAREA') do
      @mock.mock :get, 'http://localhost:3000/form?textarea=textarea', 'TEXTAREA'
      @browser.fill_in(element, :with => 'textarea')
      @browser.submit_form('form')
    end
  end

  def test_check
    perform :get, 'http://localhost:3000/', html(:checkbox)

    element = @browser.locate_element('checkbox')
    form    = @browser.locate_element('form')

    assert_response_contains('CHECKED') do
      @mock.mock :get, 'http://localhost:3000/form?checkbox=1', 'CHECKED'
      @browser.check(element)
      @browser.submit_form(form)
    end
  end

  def test_uncheck
    perform :get, 'http://localhost:3000/', html(:checkbox)

    element = @browser.locate_element('checkbox')
    form    = @browser.locate_element('form')

    assert_response_contains('FORM') do
      @mock.mock :get, 'http://localhost:3000/form', 'FORM'
      @browser.check(element)
      @browser.uncheck(element)
      @browser.submit_form(form)
    end
  end

  def test_choose
    perform :get, 'http://localhost:3000/', html(:radio)

    element = @browser.locate_element('radio')
    form    = @browser.locate_element('form')

    assert_response_contains('RADIO') do
      @mock.mock :get, 'http://localhost:3000/form?radio=radio', 'RADIO'
      @browser.choose(element)
      @browser.submit_form(form)
    end
  end

  def test_select
    perform :get, 'http://localhost:3000/', html(:select)

    option_element = @browser.locate_element('foo')
    select_element = @browser.locate_element('select')
    form           = @browser.locate_element('form')

    assert_response_contains('SELECT') do
      @mock.mock :get, 'http://localhost:3000/form?select=foo', 'SELECT'
      @browser.select(option_element, :from => select_element)
      @browser.submit_form(form)
    end
  end

  def test_attach_file
    perform :get, 'http://localhost:3000/', html(:file)

    element = @browser.locate_element('file')
    form    = @browser.locate_element('form')

    # does this test the correct thing?
    assert_response_contains('FILE') do
      @mock.mock :get, 'http://localhost:3000/form?file=rails.png', 'FILE'
      filename = TEST_ROOT + '/fixtures/rails.png'
      @browser.attach_file(element, filename)
      @browser.submit_form(form)
    end
  end

  def test_drag_and_drop
    perform :get, 'http://localhost:3000/', html(:jquery, :jquery_ui, :drag)

    drag_element = @browser.locate_element('link')
    drop_element = @browser.locate_element('form')

    @browser.drag(drag_element)
    @browser.drop(drop_element)
    assert_equal 'DROPPED!', @browser.page.getTitleText
  end

  def test_drag_and_drop_single_statement
    perform :get, 'http://localhost:3000/', html(:jquery, :jquery_ui, :drag)

    drag_element = @browser.locate_element('link')
    drop_element = @browser.locate_element('form')

    @browser.drag_and_drop(drag_element, :to => drop_element)
    assert_equal 'DROPPED!', @browser.page.getTitleText
  end

  def test_hover
    perform :get, 'http://localhost:3000/', html(:jquery, :jquery_ui, :hover)

    element = @browser.locate_element('paragraph')

    @browser.hover(element)
    assert_equal 'HOVERED!', @browser.page.getTitleText
  end

  def test_blur
    perform :get, 'http://localhost:3000/', html(:field, :jquery, :blur)

    element = @browser.locate_element('field')

    @browser.click_on(element) # not good to couple this to another action?
    @browser.blur(element)
    assert_equal 'BLURRED!', @browser.page.getTitleText
  end

  def test_focus
    perform :get, 'http://localhost:3000/', html(:field, :jquery, :focus)

    element = @browser.locate_element('field')

    @browser.focus(element)
    assert_equal 'FOCUSED!', @browser.page.getTitleText
  end

  def test_double_click
    perform :get, 'http://localhost:3000/', html(:field, :jquery, :double_click)

    element = @browser.locate_element('paragraph')

    @browser.double_click(element)
    assert_equal 'DOUBLE CLICKED!', @browser.page.getTitleText
  end
end
