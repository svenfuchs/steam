module Steam
  module Browser
    module Locators
      module HtmlUnit
        class FormLocator < Locator
          def matchable_attributes
            super + [:name]
          end
          
          def xpath
            super('form')
          end
        end
      end
    end
  end
end
