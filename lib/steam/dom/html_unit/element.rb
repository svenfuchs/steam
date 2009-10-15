module Steam
  module Dom
    module HtmlUnit
      class Element
        attr_reader :element

        def initialize(element)
          @element = element
        end
        
        def xpath
          @element.getCanonicalXPath
        end

        def inner_html
          @element.getTextContent # FIXME
        end
        
        def to_s
          @element.asXml
        end
        
        def tag_name
          @element.getTagName
        end
        
        def ancestor_of?(other)
          element.isAncestorOf(other.element)
        end
        
        def attribute(name)
          @element.attribute(name).to_s
        end
        
        def attributes(names)
          names.map { |name| attribute(name) }
        end
      end
    end
  end
end
