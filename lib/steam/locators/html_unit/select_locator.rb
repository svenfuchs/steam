module Steam
  module Locators
    module HtmlUnit
      class SelectLocator < Locator
        def matchable_attributes
          super + [:name]
        end

        def xpath
          super('select')
        end
      end
    end
  end
end
