module Steam
  module Locators
    module HtmlUnit
      class ButtonLocator < Locator
        def matchable_attributes
          super + [:name, :value, :alt]
        end

        def xpath
          "//button|//input[@type = 'submit']|//input[@type = 'button']|//input[@type = 'image']"
        end
      end
    end
  end
end
