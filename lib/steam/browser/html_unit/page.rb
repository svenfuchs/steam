# Wraps a dom.gargoylesoftware.htmlunit.html.HtmlPage (which is returned by
# most browser actions such as click, drag, drop etc.) with a nicer interface.

module Steam
  module Browser
    class HtmlUnit
      class Page
        attr_reader

        def initialize(page)
          @page = page
        end

        def url
          @page.getWebResponse.getRequestSettings.getUrl.toString
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

        def execute(javascript)
          @page.executeJavaScript(javascript)
        end

        def sourceCode
          @page.asXml
        end

        def to_a
          [body, status, headers]
        end

        def method_missing(method, *args)
          return @page.send(method, *args)
        end
      end
    end
  end
end