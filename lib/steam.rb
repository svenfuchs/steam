require 'rubygems'
require 'rack'

module Steam
  autoload :Connection, 'steam/connection'
  autoload :Browser,    'steam/browser'
  autoload :Java,       'steam/java'
  autoload :Locators,   'steam/locators'
  autoload :Matchers,   'steam/matchers'
  autoload :Reloader,   'steam/reloader'
  autoload :Request,    'steam/request'
  autoload :Session,    'steam/session'
  autoload :TestCase,   'steam/test_case'
  autoload :Utils,      'steam/utils'
end