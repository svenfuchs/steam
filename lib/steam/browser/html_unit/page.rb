module Steam
  module Browser
    class HtmlUnit
      class Page
        attr_reader :client

        def initialize(page)
          @page = page
        end

        def status
          @page.getWebResponse.getStatusCode
        end
        
        def headers
          @page.getWebResponse.getResponseHeaders.toArray.inject({}) do |headers, pair|
            headers[pair.name] = pair.value
            headers
          end
        end
        
        def body
          @page.asXml
        end
        
        def method_missing(method, *args)
          @page.send(method, *args)
        end
      end
    end
  end
end