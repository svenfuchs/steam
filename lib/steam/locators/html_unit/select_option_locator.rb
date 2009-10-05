module Steam
  module Locators
    module HtmlUnit
      class SelectOptionLocator < Locator
        def matchable_attributes
          super + [:value]
        end

        def xpath
          super('option')
        end
      end
    end
  end
end
