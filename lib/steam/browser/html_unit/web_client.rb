module Steam
  module Browser
    class HtmlUnit
      class WebClient
        attr_reader :client, :connection, :page

        def initialize
          @client = HtmlUnit::Java::WebClient.new
          @client.setCssEnabled(true)
          @client.setJavaScriptEnabled(true)

          @connection = HtmlUnit::MockConnection.new
          @client.setWebConnection(Rjb::bind(@connection.connection, 'com.gargoylesoftware.htmlunit.WebConnection'))
        end

        def process_html(request, response)
          connection.mock_response(request.uri, response)
          client.setWebConnection(Rjb::bind(connection, 'com.gargoylesoftware.htmlunit.WebConnection'))
          client.getPage(request.uri.to_s)
        end
      end
    end
  end
end