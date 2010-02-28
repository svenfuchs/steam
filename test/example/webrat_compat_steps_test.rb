require File.expand_path('../../test_helper', __FILE__)
# $: << File.expand_path("../../../lib", __FILE__)

require 'cucumber'
require 'steam'

module PathTo
  def path_to(page_name)
    "http://localhost:3000/#{page_name}"
  end
end
include PathTo

connection = Steam::Connection::Mock.new
$browser = Steam::Browser.create(connection)

$step_mother = Cucumber::StepMother.new
$step_mother.log = Logger.new(File.open('/dev/null', 'w'))
steps_file = File.expand_path('../../../example/cucumber/webrat_compatible_steps.rb', __FILE__)
$step_mother.load_code_file(steps_file)

ruby = $step_mother.load_programming_language('rb')
ruby.build_rb_world_factory([PathTo], lambda { Steam::Session.new($browser) })
ruby.send(:create_world)
ruby.send(:extend_world)

class WebratCompatStepsTest < Test::Unit::TestCase
  def setup
    @browser = $browser
  end
  
  def invoke(step)
    $step_mother.invoke(step)
  end
  
  def response
    $browser.response
  end
  
  def title
    $browser.page.getTitleText
  end
  
  def locate(*args)
    $browser.locate(*args)
  end

  test 'I go to page' do
    mock :get, path_to('foo'), 'FOO'
    invoke 'I go to foo'
    assert_match 'FOO', response.body
  end

  test 'I press "button"' do
    perform :get, path_to('foo'), %(<input type="button" id="button" onclick="document.title='OK'">)
    invoke 'I press "button"'
    assert_match 'OK', title
  end

  test 'I click on "button"' do
    perform :get, path_to('foo'), %(<input type="button" id="button" onclick="document.title='OK'">)
    invoke 'I click on "button"'
    assert_match 'OK', title
  end

  test 'I follow "link"' do
    perform :get, path_to('foo'), %(<a href="javascript:document.title='OK'">link</a>)
    invoke 'I follow "link"'
    assert_match 'OK', title
  end

  test 'I follow "link" within "foo"' do
    perform :get, path_to('foo'), %(<a>link</a><div id="foo"><a href="javascript:document.title='OK'">link</a></div>)
    invoke 'I follow "link" within "#foo"'
    assert_match 'OK', title
  end

  test 'I fill in "foo" with "OK"' do
    perform :get, path_to('foo'), %(<input type="text" name="foo" value="bar">)
    invoke 'I fill in "foo" with "OK"'
    assert_match 'OK', locate(:input).attribute('value')
  end

  test 'I fill in "foo" for "OK"' do
    perform :get, path_to('foo'), %(<input type="text" name="foo" value="bar">)
    invoke 'I fill in "OK" for "foo"'
    assert_match 'OK', locate(:input).attribute('value')
  end

  # TODO
  # When /^(?:|I )fill in the following:$/ do |fields|
  #   fields.rows_hash.each do |name, value|
  #     When %{I fill in "#{name}" with "#{value}"}
  #   end
  # end

  test 'I select "OK" from "foo"' do
    perform :get, path_to('foo'), %(<select name="foo"><option>bar</option><option>OK</option></select>)
    invoke 'I select "OK" from "foo"'
    assert_equal 'OK', locate(:select).value
  end

  # TODO
  # # When I select "December 25, 2008 10:00" as the date and time
  # When /^(?:|I )select "([^\"]*)" as the date and time$/ do |time|
  #   select_datetime(time)
  # end
  #
  # When /^(?:|I )select "([^\"]*)" as the "([^\"]*)" date and time$/ do |datetime, select|
  #   select_datetime(datetime, :from => select)
  # end
  # 
  # # Note: Rail's default time helper provides 24-hour time-- not 12 hour time. Webrat
  # # will convert the 2:20PM to 14:20 and then select it.
  # When /^(?:|I )select "([^\"]*)" as the time$/ do |time|
  #   select_time(time)
  # end
  # 
  # # When I select "7:30AM" as the "Gym" time
  # When /^(?:|I )select "([^\"]*)" as the "([^\"]*)" time$/ do |time, time_label|
  #   select_time(time, :from => time_label)
  # end
  # 
  # # When I select "February 20, 1981" as the date
  # When /^(?:|I )select "([^\"]*)" as the date$/ do |date|
  #   # reformat_date!(date)
  #   select_date(date)
  # end
  # 
  # # When I select "April 26, 1982" as the "Date of Birth" date
  # When /^(?:|I )select "([^\"]*)" as the "([^\"]*)" date$/ do |date, date_label|
  #   # reformat_date!(date)
  #   select_date(date, :from => date_label)
  # end

  test 'I check "foo"' do
    perform :get, path_to('foo'), %(<input type="checkbox" name="foo">)
    invoke 'I check "foo"'
    assert_equal 'checked', locate(:input, :type => 'checkbox').checked
  end

  test 'I uncheck "foo"' do
    perform :get, path_to('foo'), %(<input type="checkbox" name="foo" checked="checked">)
    invoke 'I uncheck "foo"'
    assert_nil locate(:check_box).checked
  end

  test 'I choose "foo"' do
    perform :get, path_to('foo'), %(<input type="radio" name="foo">)
    invoke 'I choose "foo"'
    assert_equal 'checked', locate(:radio_button).checked
  end

  test 'I attach the file at "path" to "foo"' do
    perform :get, path_to('foo'), %(<input type="file" name="foo">)
    invoke 'I attach the file at "path" to "foo"'
    assert_equal 'path', locate(:file).value
  end
  
  # I should see
  
  test 'I should see "foo" (passes)' do
    perform :get, path_to('foo'), %(foo)
    assert_passes { invoke 'I should see "foo"' }
  end

  test 'I should see "foo" (fails)' do
    perform :get, path_to('foo'), %(bar)
    assert_fails { invoke 'I should see "foo"' }
  end
  
  test 'I should see /foo/ (passes)' do
    perform :get, path_to('foo'), %(foo)
    assert_passes { invoke 'I should see /foo/' }
  end

  test 'I should see /foo/ (fails)' do
    perform :get, path_to('foo'), %(bar)
    assert_fails { invoke 'I should see /foo/' }
  end
  
  # I should not see
  
  test 'I should not see "foo" (passes)' do
    perform :get, path_to('foo'), %(bar)
    assert_passes { invoke 'I should not see "foo"' }
  end

  test 'I should not see "foo" (fails)' do
    perform :get, path_to('foo'), %(foo)
    assert_fails { invoke 'I should not see "foo"' }
  end
  
  test 'I should not see /foo/ (passes)' do
    perform :get, path_to('foo'), %(bar)
    assert_passes { invoke 'I should not see /foo/' }
  end

  test 'I should not see /foo/ (fails)' do
    perform :get, path_to('foo'), %(foo)
    assert_fails { invoke 'I should not see /foo/' }
  end
  
  # I should see within
  
  test 'I should see "bar" within "foo" (passes)' do
    perform :get, path_to('foo'), %(<div id="foo"><span>bar</span></div>)
    assert_passes { invoke 'I should see "bar" within "#foo"' }
  end
  
  test 'I should see "bar" within "foo" (fails)' do
    perform :get, path_to('foo'), %(<div id="foo"></div><span>bar</span>)
    assert_fails { invoke 'I should see "bar" within "#foo"' }
  end
  
  test 'I should see /bar/ within "foo" (passes)' do
    perform :get, path_to('foo'), %(<div id="foo"><span>foobar</span></div>)
    assert_passes { invoke 'I should see /bar/ within "#foo"' }
  end
  
  test 'I should see /bar/ within "foo" (fails)' do
    perform :get, path_to('foo'), %(<div id="foo"></div><span>foobar</span>)
    assert_fails { invoke 'I should see /bar/ within "#foo"' }
  end
  
  # I should not see within
  
  test 'I should not see "bar" within "foo" (passes)' do
    perform :get, path_to('foo'), %(<div id="foo"></div><span>bar</span>)
    assert_passes { invoke 'I should not see "bar" within "#foo"' }
  end
  
  test 'I should not see "bar" within "foo" (fails)' do
    perform :get, path_to('foo'), %(<div id="foo"><span>bar</span></div>)
    assert_fails { invoke 'I should not see "bar" within "#foo"' }
  end
  
  test 'I should not see /bar/ within "foo" (passes)' do
    perform :get, path_to('foo'), %(<div id="foo"></div><span>bar</span>)
    assert_passes { invoke 'I should not see /bar/ within "#foo"' }
  end
  
  test 'I should not see /bar/ within "foo" (fails)' do
    perform :get, path_to('foo'), %(<div id="foo"><span>foobar</span></div>)
    assert_fails { invoke 'I should not see /bar/ within "#foo"' }
  end
  
  # field should contain
  
  test 'the "foo" field should contain "bar" (passes)' do
    perform :get, path_to('foo'), %(<input type="text" name="foo" value="bar">)
    assert_passes { invoke 'the "foo" field should contain "bar"' }
  end
  
  test 'the "foo" field should contain "bar" (fails)' do
    perform :get, path_to('foo'), %(<input type="text" name="foo" value="foo">)
    assert_fails { invoke 'the "foo" field should contain "bar"' }
  end
  
  # field should not contain
  
  test 'the "foo" field should not contain "bar" (passes)' do
    perform :get, path_to('foo'), %(<input type="text" name="foo" value="foo">)
    assert_passes { invoke 'the "foo" field should not contain "bar"' }
  end
  
  test 'the "foo" field should not contain "bar" (fails)' do
    perform :get, path_to('foo'), %(<input type="text" name="foo" value="bar">)
    assert_fails { invoke 'the "foo" field should not contain "bar"' }
  end
  
  # checkbox should be checked
  
  test 'the "foo" checkbox should be checked (passes)' do
    perform :get, path_to('foo'), %(<input type="checkbox" name="foo" checked="checked">)
    assert_passes { invoke 'the "foo" checkbox should be checked' }
  end
  
  test 'the "foo" checkbox should be checked (fails)' do
    perform :get, path_to('foo'), %(<input type="checkbox" name="foo">)
    assert_fails { invoke 'the "foo" checkbox should be checked' }
  end
  
  # checkbox should not be checked
  
  test 'the "foo" checkbox should not be checked (passes)' do
    perform :get, path_to('foo'), %(<input type="checkbox" name="foo">)
    assert_passes { invoke 'the "foo" checkbox should not be checked' }
  end
  
  test 'the "foo" checkbox should not be checked (fails)' do
    perform :get, path_to('foo'), %(<input type="checkbox" name="foo" checked="checked">)
    assert_fails { invoke 'the "foo" checkbox should not be checked' }
  end
  
  # I should be on
  
  test 'I should be on foo (passes)' do
    perform :get, path_to('foo'), ''
    assert_passes { invoke 'I should be on foo' }
  end
  
  test 'I should be on foo (fails)' do
    perform :get, path_to('bar'), ''
    assert_fails { invoke 'I should be on foo' }
  end
end