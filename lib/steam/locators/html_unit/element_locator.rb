module Steam
  module Locators
    module HtmlUnit
      class ElementLocator < Locator
        def matchable_attributes
          super + [:name, :value]
        end

        def xpath
          super(selector.is_a?(Symbol) ? selector : '*')
        end
      end
    end
  end
end
