require File.expand_path(File.dirname(__FILE__) + '/../test_helper')
require 'erb'

class HtmlUnitTest < Test::Unit::TestCase
  include Steam
  include TestHelper
  include HtmlUnitHelper

  def test_browser_loads_and_evaluates_linked_javascripts
    perform :get, 'http://localhost:3000/', html(:foo)
    assert_match %r(<title>\s*FOO\s*<\/title>), @response.body.join
  end

  def test_click_on_clicks_a_link
    perform :get, 'http://localhost:3000/', html

    assert_response_contains('LINK') do
      @mock.mock :get, 'http://localhost:3000/link', 'LINK'
      @browser.click_on('link')
    end
  end

  def test_click_on_clicks_a_button
    perform :get, 'http://localhost:3000/', html(:field)

    assert_response_contains('FORM') do
      @mock.mock :get, 'http://localhost:3000/form?field=', 'FORM'
      @browser.click_on('button')
    end
  end

  def test_click_link
    perform :get, 'http://localhost:3000/', html(:foo)

    assert_response_contains('LINK') do
      @mock.mock :get, 'http://localhost:3000/link', 'LINK'
      @browser.click_link('link')
    end
  end

  def test_click_button
    perform :get, 'http://localhost:3000/', html(:field)

    assert_response_contains('FORM') do
      @mock.mock :get, 'http://localhost:3000/form?field=', 'FORM'
      @browser.click_button('button')
    end
  end

  def test_submit_form
    perform :get, 'http://localhost:3000/', html(:field)

    assert_response_contains('FORM') do
      @mock.mock :get, 'http://localhost:3000/form?field=', 'FORM'
      @browser.submit_form('form')
    end
  end

  def test_fill_in
    perform :get, 'http://localhost:3000/', html(:field)

    assert_response_contains('FIELD') do
      @mock.mock :get, 'http://localhost:3000/form?field=field', 'FIELD'
      @browser.fill_in('field', :with => 'field')
      @browser.submit_form('form')
    end
  end

  def test_fill_in_with_label_text
    perform :get, 'http://localhost:3000/', html(:field)

    assert_response_contains('FIELD') do
      @mock.mock :get, 'http://localhost:3000/form?field=field', 'FIELD'
      @browser.fill_in('Label for field', :with => 'field')
      @browser.submit_form('form')
    end
  end

  def test_fill_in_textarea
    perform :get, 'http://localhost:3000/', html(:textarea)

    assert_response_contains('TEXTAREA') do
      @mock.mock :get, 'http://localhost:3000/form?textarea=textarea', 'TEXTAREA'
      @browser.fill_in('textarea', :with => 'textarea')
      @browser.submit_form('form')
    end
  end

  def test_fill_in_textarea_with_label_text
    perform :get, 'http://localhost:3000/', html(:textarea)

    assert_response_contains('TEXTAREA') do
      @mock.mock :get, 'http://localhost:3000/form?textarea=textarea', 'TEXTAREA'
      @browser.fill_in('Label for textarea', :with => 'textarea')
      @browser.submit_form('form')
    end
  end

  def test_check
    perform :get, 'http://localhost:3000/', html(:checkbox)

    assert_response_contains('CHECKED') do
      @mock.mock :get, 'http://localhost:3000/form?checkbox=1', 'CHECKED'
      @browser.check('checkbox')
      @browser.submit_form('form')
    end
  end

  def test_check_with_label_text
    perform :get, 'http://localhost:3000/', html(:checkbox)

    assert_response_contains('CHECKED') do
      @mock.mock :get, 'http://localhost:3000/form?checkbox=1', 'CHECKED'
      @browser.check('Label for checkbox')
      @browser.submit_form('form')
    end
  end

  def test_uncheck
    perform :get, 'http://localhost:3000/', html(:checkbox)

    assert_response_contains('FORM') do
      @mock.mock :get, 'http://localhost:3000/form', 'FORM'
      @browser.check('checkbox')
      @browser.uncheck('checkbox')
      @browser.submit_form('form')
    end
  end

  def test_uncheck_with_label_text
    perform :get, 'http://localhost:3000/', html(:checkbox)

    assert_response_contains('FORM') do
      @mock.mock :get, 'http://localhost:3000/form', 'FORM'
      @browser.check('checkbox')
      @browser.uncheck('Label for checkbox')
      @browser.submit_form('form')
    end
  end

  def test_choose
    perform :get, 'http://localhost:3000/', html(:radio)

    assert_response_contains('RADIO') do
      @mock.mock :get, 'http://localhost:3000/form?radio=radio', 'RADIO'
      @browser.choose('radio')
      @browser.submit_form('form')
    end
  end

  def test_choose_with_label_text
    perform :get, 'http://localhost:3000/', html(:radio)

    assert_response_contains('RADIO') do
      @mock.mock :get, 'http://localhost:3000/form?radio=radio', 'RADIO'
      @browser.choose('Label for radio')
      @browser.submit_form('form')
    end
  end

  def test_select
    perform :get, 'http://localhost:3000/', html(:select)

    assert_response_contains('SELECT') do
      @mock.mock :get, 'http://localhost:3000/form?select=foo', 'SELECT'
      @browser.select('foo', :from => 'select')
      @browser.submit_form('form')
    end
  end

  def test_select_with_label_text
    perform :get, 'http://localhost:3000/', html(:select)

    assert_response_contains('SELECT') do
      @mock.mock :get, 'http://localhost:3000/form?select=foo', 'SELECT'
      @browser.select('foo', :from => 'Label for select')
      @browser.submit_form('form')
    end
  end

  def test_attach_file
    perform :get, 'http://localhost:3000/', html(:file)

    # does this test the correct thing?
    assert_response_contains('FILE') do
      @mock.mock :get, 'http://localhost:3000/form?file=rails.png', 'FILE'
      filename = TEST_ROOT + '/fixtures/rails.png'
      @browser.attach_file('file', filename)
      @browser.submit_form('form')
    end
  end

  def test_attach_file_with_label_text
    perform :get, 'http://localhost:3000/', html(:file)

    # does this test the correct thing?
    assert_response_contains('FILE') do
      @mock.mock :get, 'http://localhost:3000/form?file=rails.png', 'FILE'
      filename = TEST_ROOT + '/fixtures/rails.png'
      @browser.attach_file('Label for file', filename)
      @browser.submit_form('form')
    end
  end

  def test_current_url
    perform :get, 'http://localhost:3000/', html(:field)
    @mock.mock :get, 'http://localhost:3000/form?field=field', 'FIELD'

    assert_equal 'http://localhost:3000/', @browser.current_url

    @browser.fill_in('Label for field', :with => 'field')
    @browser.submit_form('form')
    assert_equal 'http://localhost:3000/form?field=field', @browser.current_url
  end

  def test_drag_and_drop
    perform :get, 'http://localhost:3000/', html(:jquery, :jquery_ui, :drag)

    @browser.drag('link')
    @browser.drop('form')
    assert_equal 'DROPPED!', @browser.page.getTitleText
  end

  def test_drag_and_drop_single_statement
    perform :get, 'http://localhost:3000/', html(:jquery, :jquery_ui, :drag)

    @browser.drag_and_drop('link', :to => 'form')
    assert_equal 'DROPPED!', @browser.page.getTitleText
  end

  def test_hover
    perform :get, 'http://localhost:3000/', html(:jquery, :hover)

    @browser.hover('paragraph')
    assert_equal 'HOVERED!', @browser.page.getTitleText
  end

  def test_blur
    perform :get, 'http://localhost:3000/', html(:field, :jquery, :blur)

    @browser.click_on('field') # not good to couple this to another action?
    @browser.blur('field')
    assert_equal 'BLURRED!', @browser.page.getTitleText
  end

  def test_focus
    perform :get, 'http://localhost:3000/', html(:field, :jquery, :focus)

    @browser.focus('field')
    assert_equal 'FOCUSED!', @browser.page.getTitleText
  end

  def test_double_click
    perform :get, 'http://localhost:3000/', html(:field, :jquery, :double_click)

    @browser.double_click('paragraph')
    assert_equal 'DOUBLE CLICKED!', @browser.page.getTitleText
  end
end
