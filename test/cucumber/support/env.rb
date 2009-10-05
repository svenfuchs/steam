require 'rubygems'
require 'cucumber/formatter/unicode'

ENV["RAILS_ENV"] ||= "cucumber"

require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
ActiveRecord::Base.establish_connection(:test)

Before do
end

