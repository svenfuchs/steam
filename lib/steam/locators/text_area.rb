module Steam
  module Locators
    class TextArea < Base
      def matchable_attributes
        super + [:name]
      end

      def xpath
        super('textarea')
      end
    end
  end
end