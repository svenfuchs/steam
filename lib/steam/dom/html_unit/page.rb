require 'core_ext/ruby/kernel/silence_warnings'

module Steam
  module Dom
    module HtmlUnit
      class Page
        class << self
          def build(page, html)
            page ||= begin
              url      = 'http://www.example.com'
              url      = Steam::Java::Url.new(url)
              client   = Steam::Java::WebClient.new
              window   = Steam::Java::TopLevelWindow.new('window', client)
              response = Steam::Java::StringWebResponse.new(html, url)
              Steam::Java::DefaultPageCreator.new.createPage(response, window)
            end
            page.respond_to?(:elements_by_xpath) ? page : new(page)
          end
        end
        
        def initialize(page)
          @page = page
        end
        
        def element_by_id(id)
          elements_by_xpath("//*[@id='#{id}']").first
        end
        
        def elements_by_xpath(xpath)
          elements = @page.getByXPath(xpath)
          elements = silence_warnings { elements.toArray }
          elements.map { |element| Element.new(element) }
        end
      end
    end
  end
end