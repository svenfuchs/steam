module Steam
  class Session
    autoload :Rails, 'steam/session/rails'

    attr_accessor :id, :browser

    def initialize(browser = nil)
      @browser = browser
    end

    # FIXME - there has to be a better way to enforce this - how does webrat handle it?
    def select(*args, &block)
      browser.select(*args, &block)
    end

    def respond_to?(method)
      browser.respond_to?(method) ? true : super
    end

    def method_missing(method, *args, &block)
      return browser.send(method, *args, &block) # if browser.respond_to?(method)
      super
    end
  end
end