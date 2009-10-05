module Steam
  module Locators
    module HtmlUnit
      class ElementLocator < Locator
        def matchable_attributes
          super + [:name, :value]
        end

        def xpath
          "*//*"
        end
      end
    end
  end
end
