module Steam
  module Locators
    class Label < Base
      def xpath
        super('label')
      end
    end
  end
end
