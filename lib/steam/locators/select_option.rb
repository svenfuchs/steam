module Steam
  module Locators
    class SelectOption < Base
      def matchable_attributes
        super + [:value]
      end

      def xpath
        super('option')
      end
    end
  end
end