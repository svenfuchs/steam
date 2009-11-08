module Steam
  module Locators
    class Select < Base
      def matchable_attributes
        super + [:name]
      end

      def xpath
        super('select')
      end

      def locate
        return elements[0] unless selector

        element = elements_with_matching_values + labeled_elements
        element = select_by_min_matching_attribute(element)
        element = select_element_for(element) if element && element.tag_name == 'label'
        element
      end

      def labeled_elements
        Label.new(dom, scope, selector).elements_with_matching_values
      end

      def select_element_for(label)
        id = label.attribute('for')
        dom.element_by_id(id)
      end
    end
  end
end