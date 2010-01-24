module Steam
  module Locators
    class Label < Base
      def matchable_attributes
        super + [:for]
      end

      def xpath
        super('label')
      end
    end
  end
end
