# Conceptually a session is something different than a browser. E.g. a (test-)
# session can be started (setting up test data etc.) and stopped (cleaning
# stuff up etc.). Webrat and Capybara don't separate these concepts. So let's
# keep them separate though from the beginning even though we don't implement
# any such behavior so far.

module Steam
  class Session
    autoload :Rails, 'steam/session/rails'

    include Locator::Matcher
    include Test::Unit::Assertions if defined?(Test::Unit)
    # TODO include Rspec::Something if defined?(Rspec)

    attr_accessor :browser

    def initialize(browser = nil)
      @browser = browser
    end

    def respond_to?(method)
      browser.respond_to?(method) ? true : super
    end

    def method_missing(method, *args, &block)
      return browser.send(method, *args, &block) # if browser.respond_to?(method)
      super
    end

    def select(*args, &block) # because Class implements #select
      browser.select(*args, &block)
    end
  end
end