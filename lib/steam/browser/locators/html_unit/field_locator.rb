module Steam
  module Browser
    module Locators
      module HtmlUnit
        class FieldLocator < Locator
          def initialize(page, *types)
            types = ['text'] if types.empty?
            super(page, 'type' => types)
          end
          
          def matchable_attributes
            super + [:name]
          end
          
          def xpath
            super('input')
          end

          def locate(value = nil)
            return elements[0] unless value

            elements = elements_with_matching_values(value) + labeled_elements(value)
            element = select_by_min_matching_attribute(elements, value)
            element = input_element_for(element) if element && element._classname.include?('HtmlLabel')
            element
          end
          
          def labeled_elements(value)
            LabelLocator.new(page).elements_with_matching_values(value)
          end
          
          def input_element_for(label)
            id = label.getForAttribute
            page.getElementById(id)
          end
        end
      end
    end
  end
end
