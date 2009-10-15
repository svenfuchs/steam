module Steam
  module Locators
    class Field < Base
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

      def locate
        return elements[0] unless selector

        elements = elements_with_matching_values + labeled_elements
        element = select_by_min_matching_attribute(elements)
        element = input_element_for(element) if element && element.tag_name == 'label'
        element
      end

      def labeled_elements
        Label.new(dom, scope, selector).elements_with_matching_values
      end

      def input_element_for(label)
        id = label.attribute('for')
        dom.element_by_id(id)
      end
    end
  end
end