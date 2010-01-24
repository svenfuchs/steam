require File.expand_path(File.dirname(__FILE__) + '/../test_helper')
require 'erb'

class HtmlUnitRailsActionsTest < Test::Unit::TestCase
  include Steam
  include TestHelper
  include HtmlUnitHelper

  def setup
    super

    # @mock.mock :get, "http://localhost:3000/form?event_date(1i)=2009&event_date(2i)=11&event_date(3i)=7", 'DATE'
    # huh? how is this encoded?
    @mock.mock :get, "http://localhost:3000/form?event_date%281i%29=2009&event_date%282i%29=11&event_date%283i%29=7", 'DATE'

    # @mock.mock :get, "http://localhost:3000/form?event_datetime(1i)=2009&event_datetime(2i)=11&event_datetime(3i)=7&event_datetime(4i)=19&event_datetime(5i)=0", 'DATETIME'
    # huh? how is this encoded?
    @mock.mock :get, "http://localhost:3000/form?event_datetime%281i%29=2009&event_datetime%282i%29=11&event_datetime%283i%29=7&event_datetime%284i%29=19&event_datetime%285i%29=0", 'DATETIME'

    # @mock.mock :get, "http://localhost:3000/form?event_time(4i)=19&event_time(5i)=0", 'TIME'
    # huh? how is this encoded?
    @mock.mock :get, "http://localhost:3000/form?event_time%284i%29=19&event_time%285i%29=0", 'TIME'
  end

  def test_select_date
    perform :get, 'http://localhost:3000/', html(:date)

    assert_response_contains('DATE') do
      @browser.select_date('7 November 2009', :from => 'event_date')
      @browser.submit_form('form')
    end
  end

  def test_select_date_works_with_date_object
    perform :get, 'http://localhost:3000/', html(:date)

    assert_response_contains('DATE') do
      @browser.select_date(Date.parse('7 November 2009'), :from => 'event_date')
      @browser.submit_form('form')
    end
  end

  def test_select_date_works_with_label
    perform :get, 'http://localhost:3000/', html(:date)

    assert_response_contains('DATE') do
      @browser.select_date('7 November 2009', :from => 'Date')
      @browser.submit_form('form')
    end
  end

  def test_select_date_works_without_from_option
    perform :get, 'http://localhost:3000/', html(:date)

    assert_response_contains('DATE') do
      @browser.select_date('7 November 2009')
      @browser.submit_form('form')
    end
  end

  def test_select_date_works_with_id_prefix_option
    perform :get, 'http://localhost:3000/', html(:date)

    assert_response_contains('DATE') do
      @browser.select_date('7 November 2009', :id_prefix => 'event_date')
      @browser.submit_form('form')
    end
  end

  def test_select_datetime
    perform :get, 'http://localhost:3000/', html(:datetime)

    assert_response_contains('DATETIME') do
      @browser.select_datetime('7 November 2009, 19:00', :from => 'event_datetime')
      @browser.submit_form('form')
    end
  end

  def test_select_datetime_works_with_datetime_object
    perform :get, 'http://localhost:3000/', html(:datetime)

    assert_response_contains('DATETIME') do
      @browser.select_datetime(Time.parse('7 November 2009, 19:00'), :from => 'event_datetime')
      @browser.submit_form('form')
    end
  end

  def test_select_datetime_works_with_label
    perform :get, 'http://localhost:3000/', html(:datetime)

    assert_response_contains('DATETIME') do
      @browser.select_datetime('7 November 2009, 19:00', :from => 'Datetime')
      @browser.submit_form('form')
    end
  end

  def test_select_datetime_works_without_from_option
    perform :get, 'http://localhost:3000/', html(:datetime)

    assert_response_contains('DATETIME') do
      @browser.select_datetime('7 November 2009, 19:00')
      @browser.submit_form('form')
    end
  end

  def test_select_datetime_works_with_id_prefix_option
    perform :get, 'http://localhost:3000/', html(:datetime)

    assert_response_contains('DATETIME') do
      @browser.select_datetime('7 November 2009, 19:00', :id_prefix => 'event_datetime')
      @browser.submit_form('form')
    end
  end

  def test_select_time
    perform :get, 'http://localhost:3000/', html(:time)

    assert_response_contains('TIME') do
      @browser.select_time('19:00', :from => 'event_time')
      @browser.submit_form('form')
    end
  end

  def test_select_time_works_with_time_object
    perform :get, 'http://localhost:3000/', html(:time)

    assert_response_contains('TIME') do
      @browser.select_time(Time.parse('19:00'), :from => 'event_time')
      @browser.submit_form('form')
    end
  end

  def test_select_time_works_with_label
    perform :get, 'http://localhost:3000/', html(:time)

    assert_response_contains('TIME') do
      @browser.select_time('19:00', :from => 'Time')
      @browser.submit_form('form')
    end
  end

  def test_select_time_works_without_from_option
    perform :get, 'http://localhost:3000/', html(:time)

    assert_response_contains('TIME') do
      @browser.select_time('19:00')
      @browser.submit_form('form')
    end
  end

  def test_select_time_works_with_id_prefix_option
    perform :get, 'http://localhost:3000/', html(:time)

    assert_response_contains('TIME') do
      @browser.select_time('19:00', :id_prefix => 'event_time')
      @browser.submit_form('form')
    end
  end
end
