ENV["RAILS_ENV"] ||= "cucumber"

require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
require 'steam'
require 'test/unit'
# require 'rspec'

Steam.config[:html_unit][:java_path] = 'path/to/your/htmlunit-2.6'

browser = Steam::Browser.create
World do
  Steam::Session::Rails.new(browser)
end

at_exit { browser.close }
