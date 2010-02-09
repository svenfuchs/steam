# require 'active_support/test_case'
# require 'steam/session'
# 
# module Steam
#   module Rails
#     class TestCase < ActiveSupport::TestCase
#       attr_reader :session
#       delegate :browser, :request, :response, :headers, :session, :get, :post, :put, :delete, :head, :to => :@session
#       delegate :status, :to => :response
# 
#       setup do |test|
#         test.init
#       end
# 
#       teardown do |test|
#         test.reset!
#       end
# 
#       def init
#         browser = Steam::Browser::HtmlUnit.new
#         @session = Steam::Session.new(browser)
#       end
# 
#       def reset!
#         @session.stop
#         @session = nil
#       end
#     end
#   end
# end