module Steam
  module Locators
    class Element < Base
      def matchable_attributes
        super + [:name, :value]
      end

      def xpath
        super(selector.is_a?(Symbol) ? selector : '*')
      end
    end
  end
end