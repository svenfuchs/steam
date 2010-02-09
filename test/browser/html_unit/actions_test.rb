require File.expand_path('../../../test_helper', __FILE__)
require 'fixtures/html_fakes'

class HtmlUnitActionsTest < Test::Unit::TestCase
  include Steam, HtmlFakes

  def setup
    @app = Steam::Connection::Mock.new
    static = Steam::Connection::Static.new(:root => FIXTURES_PATH)
    @browser = Steam::Browser::HtmlUnit.new(Rack::Cascade.new([static, @app]))
  end

  test "click_on clicks on an element" do
    perform :get, 'http://localhost:3000/', html
  
    assert_response_contains('LINK') do
      @app.mock :get, 'http://localhost:3000/link', 'LINK'
      @browser.click_on('link')
    end
  end

  test "click_on clicks a button" do 
    perform :get, 'http://localhost:3000/', html(:fields => :text)
    
    assert_response_contains('FORM') do
      @app.mock :get, 'http://localhost:3000/form?field=', 'FORM'
      @browser.click_on(:button, 'button')
    end
  end
  
  test "click_link clicks a link" do 
    perform :get, 'http://localhost:3000/', html
  
    assert_response_contains('LINK') do
      @app.mock :get, 'http://localhost:3000/link', 'LINK'
      @browser.click_link('link')
    end
  end
  
  test "click_button clicks a button" do
    perform :get, 'http://localhost:3000/', html(:fields => :text)
  
    assert_response_contains('FORM') do
      @app.mock :get, 'http://localhost:3000/form?field=', 'FORM'
      @browser.click_button('button')
    end
  end
  
  test "fill_in fills in a text input" do
    perform :get, 'http://localhost:3000/', html(:fields => :text)
  
    assert_response_contains('FIELD') do
      @app.mock :get, 'http://localhost:3000/form?field=text', 'FIELD'
      @browser.fill_in('field', :with => 'text')
      @browser.click_button('button')
    end
  end
  
  test "fill_in fills in a textarea" do
    perform :get, 'http://localhost:3000/', html(:fields => :textarea)
  
    assert_response_contains('TEXTAREA') do
      @app.mock :get, 'http://localhost:3000/form?textarea=text', 'TEXTAREA'
      @browser.fill_in('textarea', :with => 'text')
      @browser.click_button('button')
    end
  end
  
  test "check checks a checkbox" do
    perform :get, 'http://localhost:3000/', html(:fields => :checkbox)
  
    assert_response_contains('CHECKED') do
      @app.mock :get, 'http://localhost:3000/form?checkbox=1', 'CHECKED'
      @browser.check('checkbox')
      @browser.click_button('button')
    end
  end
  
  test "uncheck unchecks a checkbox" do
    perform :get, 'http://localhost:3000/', html(:fields => :checkbox)
  
    assert_response_contains('FORM') do
      @app.mock :get, 'http://localhost:3000/form', 'FORM'
      @browser.check('checkbox')
      @browser.uncheck('checkbox')
      @browser.click_button('button')
    end
  end
  
  test "choose activates a radio button" do
    perform :get, 'http://localhost:3000/', html(:fields => :radio)
  
    assert_response_contains('RADIO') do
      @app.mock :get, 'http://localhost:3000/form?radio=radio', 'RADIO'
      @browser.choose('radio')
      @browser.click_button('button')
    end
  end
  
  test "select selects an option from a select box" do
    perform :get, 'http://localhost:3000/', html(:fields => :select)
  
    assert_response_contains('SELECT') do
      @app.mock :get, 'http://localhost:3000/form?select=foo', 'SELECT'
      @browser.select('foo', :from => 'select')
      @browser.click_button('button')
    end
  end
  
  test "set_hidden_field sets a value to a hidden field" do
    perform :get, 'http://localhost:3000/', html(:fields => :hidden)
  
    assert_response_contains('SELECT') do
      @app.mock :get, 'http://localhost:3000/form?hidden=foo', 'SELECT'
      @browser.set_hidden_field('hidden', :to => 'foo')
      @browser.click_button('button')
    end
  end
  
  test "attach_file sets a filename to a file field" do
    perform :get, 'http://localhost:3000/', html(:fields => :file)
  
    assert_response_contains('FILE') do
      @app.mock :get, 'http://localhost:3000/form?file=rails.png', 'FILE'
      @browser.attach_file('file', "#{TEST_ROOT}/fixtures/rails.png")
      @browser.click_button('button')
    end
  end
  
  test "submit_form submits a form" do
    perform :get, 'http://localhost:3000/', html(:fields => :text)
  
    assert_response_contains('FORM') do
      @app.mock :get, 'http://localhost:3000/form?field=', 'FORM'
      @browser.submit_form('form')
    end
  end
  
  test "drag drags an draggable and drop drops the draggable onto a droppable" do
    perform :get, 'http://localhost:3000/', html(:scripts => [:jquery, :jquery_ui, :drag])
  
    @browser.drag('link')
    @browser.drop('form')
    assert_equal 'DROPPED!', @browser.page.getTitleText
  end
  
  test "drag_and_drop drags a draggable and drops it onto a droppable" do
    perform :get, 'http://localhost:3000/', html(:scripts => [:jquery, :jquery_ui, :drag])
  
    @browser.drag_and_drop('link', :to => 'form')
    assert_equal 'DROPPED!', @browser.page.getTitleText
  end
  
  test "hover triggers a mouseOver event on an element" do
    perform :get, 'http://localhost:3000/', html(:scripts => [:jquery, :jquery_ui, :hover])
  
    @browser.hover('paragraph')
    assert_equal 'HOVERED!', @browser.page.getTitleText
  end
  
  test "focus triggers a focus event on an element" do
    perform :get, 'http://localhost:3000/', html(:fields => :text, :scripts => [:jquery, :jquery_ui, :focus])
  
    @browser.focus('field')
    assert_equal 'FOCUSED!', @browser.page.getTitleText
  end
  
  test "blur triggers a blur event on an element" do
    perform :get, 'http://localhost:3000/', html(:fields => :text, :scripts => [:jquery, :jquery_ui, :blur])
  
    @browser.focus('field')
    @browser.blur('field')
    assert_equal 'BLURRED!', @browser.page.getTitleText
  end
  
  test "double_click doubleclicks an element" do
    perform :get, 'http://localhost:3000/', html(:scripts => [:jquery, :jquery_ui, :double_click])
  
    @browser.double_click('paragraph')
    assert_equal 'DOUBLE CLICKED!', @browser.page.getTitleText
  end
  
end