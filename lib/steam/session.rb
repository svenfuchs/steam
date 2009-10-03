module Steam
  class Session
    cattr_accessor :host

    attr_accessor :id, :browser, :request, :response, :session, :cookies
    delegate :headers, :to => :response

    def initialize(browser)
      @browser = browser
      @id = start
    end

    def start
      # response = post('/test/sessions')
      # raise unless response.code == '200'
      # response.body
    end

    def stop
      # delete("/test/sessions/#{id}")
    end

    [:get, :post, :put, :delete, :head].each do |method|
      class_eval <<-code
        def #{method}(uri, params = {}, headers = {})
          @response = browser.process(Request.new(method, uri, params, headers))
        end
      code
    end

    def redirect?
      response.status/100 == 3
    end

    # def follow_redirect!
    #   # raise "not a redirect! #{@status} #{@status_message}" unless redirect?
    #   get(headers['location'])
    #   status
    # end
  end
end