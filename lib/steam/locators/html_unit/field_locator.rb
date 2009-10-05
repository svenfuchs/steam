module Steam
  module Locators
    module HtmlUnit
      class FieldLocator < Locator
        def initialize(dom, *args)
          attributes = args.last.is_a?(Hash) ? args.pop : {}
          attributes[:type] = 'text' unless attributes.has_key?(:type)
          scope = args.shift
          super(dom, scope, attributes)
        end

        def matchable_attributes
          super + [:name]
        end

        def xpath
          # [".//button", ".//input", ".//textarea", ".//select"] # FIXME
          super('input')
        end

        def locate(selector = nil)
          return elements[0] unless selector

          elements = elements_with_matching_values(selector) + labeled_elements(selector)
          element = select_by_min_matching_attribute(elements)
          element = input_element_for(element) if element && element._classname.include?('HtmlLabel')
          element
        end

        def labeled_elements(selector)
          LabelLocator.new(dom, scope).elements_with_matching_values(selector)
        end

        def input_element_for(label)
          id = label.getForAttribute
          dom.getElementById(id)
        end
      end
    end
  end
end
