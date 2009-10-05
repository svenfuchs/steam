module Steam
  module Locators
    module HtmlUnit
      class TextAreaLocator < Locator
        def matchable_attributes
          super + [:name]
        end

        def xpath
          super('textarea')
        end
      end
    end
  end
end
