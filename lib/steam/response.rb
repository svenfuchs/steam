module Steam
  class Response
    attr_accessor :body, :status, :headers, :cookies

    def initialize(body = '', status = 200, headers = {}, cookies = {})
      @body    = body
      @status  = status.to_i
      @headers = headers
      @cookies = cookies
    end
    
    def html?
      content_type.include?('text/html')
    end
    
    def content_type
      headers[:content_type] || 'text/html'
    end
    
    def javascript_urls
      body.scan(%r(<script src="(/javascripts/[\w\.\-_]*(?:\?[\d]+)?)?")).flatten
    end
    
    def stylesheet_urls
      body.scan(%r(<link href="(/stylesheets/[\w\.\-_]*(?:\?[\d]+)?)?")).flatten
    end
  end
end