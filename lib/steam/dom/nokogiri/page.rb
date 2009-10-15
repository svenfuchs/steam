module Steam
  module Dom
    module Nokogiri
      class Page
        class << self
          def build(dom, html)
            dom = ::Nokogiri::HTML::Document.parse(html) unless dom.respond_to?(:elements_by_xpath)
            dom.respond_to?(:elements_by_xpath) ? dom : new(dom)
          end
        end
        
        def initialize(dom)
          @dom = dom
        end
        
        def element_by_id(id)
          elements_by_xpath("//*[@id='#{id}']").first
        end
        
        def elements_by_xpath(xpath)
          @dom.xpath(xpath).map { |element| Element.new(element) }
        end
      end
    end
  end
end