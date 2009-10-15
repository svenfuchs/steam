module Steam
  module Locators
    class Form < Base
      def matchable_attributes
        super + [:name]
      end

      def xpath
        super('form')
      end
    end
  end
end