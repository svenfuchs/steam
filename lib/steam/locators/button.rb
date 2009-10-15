module Steam
  module Locators
    class Button < Base
      def matchable_attributes
        super + [:name, :value, :alt]
      end

      def xpath
        "//button|//input[@type = 'submit']|//input[@type = 'button']|//input[@type = 'image']"
      end
    end
  end
end