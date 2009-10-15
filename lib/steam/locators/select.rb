module Steam
  module Locators
    class Select < Base
      def matchable_attributes
        super + [:name]
      end

      def xpath
        super('select')
      end
    end
  end
end