module Steam
  module Locators
    module HtmlUnit
      class AreaLocator < Locator
        def matchable_attributes
          super + [:alt]
        end

        def xpath
          super('area')
        end
      end
    end
  end
end
