module Steam
  module Locators
    class Area < Base
      def matchable_attributes
        super + [:alt]
      end

      def xpath
        super('area')
      end
    end
  end
end