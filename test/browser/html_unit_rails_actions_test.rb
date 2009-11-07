require File.expand_path(File.dirname(__FILE__) + '/../test_helper')
require 'erb'

class HtmlUnitRailsActionsTest < Test::Unit::TestCase
  include Steam
  include TestHelper
  include HtmlUnitHelper

  def setup
    super

    # @mock.mock :get, "http://localhost:3000/form?date(1i)=2009&date(2i)=11&date(3i)=7", 'DATE'
    # huh? how is this encoded?
    @mock.mock :get, "http://localhost:3000/form?date%281i%29=2009&date%282i%29=11&date%283i%29=7", 'DATE'

    # @mock.mock :get, "http://localhost:3000/form?datetime(1i)=2009&datetime(2i)=11&datetime(3i)=7&datetime(4i)=19&datetime(5i)=0", 'DATETIME'
    # huh? how is this encoded?
    @mock.mock :get, "http://localhost:3000/form?datetime%281i%29=2009&datetime%282i%29=11&datetime%283i%29=7&datetime%284i%29=19&datetime%285i%29=0", 'DATETIME'

    # @mock.mock :get, "http://localhost:3000/form?time(4i)=19&time(5i)=0", 'TIME'
    # huh? how is this encoded?
    @mock.mock :get, "http://localhost:3000/form?time%284i%29=19&time%285i%29=0", 'TIME'
  end

  def test_select_date
    perform :get, 'http://localhost:3000/', html(:date)

    assert_response_contains('DATE') do
      @browser.select_date('7 November 2009', :from => 'date')
      @browser.submit_form('form')
    end
  end

  def test_select_date_works_with_date_object
    perform :get, 'http://localhost:3000/', html(:date)

    assert_response_contains('DATE') do
      @browser.select_date(Date.parse('7 November 2009'), :from => 'date')
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
      @browser.select_date('7 November 2009', :id_prefix => 'date')
      @browser.submit_form('form')
    end
  end

  def test_select_datetime
    perform :get, 'http://localhost:3000/', html(:datetime)

    assert_response_contains('DATETIME') do
      @browser.select_datetime('7 November 2009, 19:00', :from => 'datetime')
      @browser.submit_form('form')
    end
  end

  def test_select_datetime_works_with_datetime_object
    perform :get, 'http://localhost:3000/', html(:datetime)

    assert_response_contains('DATETIME') do
      @browser.select_datetime(Time.parse('7 November 2009, 19:00'), :from => 'datetime')
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
      @browser.select_datetime('7 November 2009, 19:00', :id_prefix => 'datetime')
      @browser.submit_form('form')
    end
  end

  def test_select_time
    perform :get, 'http://localhost:3000/', html(:time)

    assert_response_contains('TIME') do
      @browser.select_time('19:00', :from => 'time')
      @browser.submit_form('form')
    end
  end

  def test_select_time_works_with_time_object
    perform :get, 'http://localhost:3000/', html(:time)

    assert_response_contains('TIME') do
      @browser.select_time(Time.parse('19:00'), :from => 'time')
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
      @browser.select_time('19:00', :id_prefix => 'time')
      @browser.submit_form('form')
    end
  end
end
