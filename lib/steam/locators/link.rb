module Steam
  module Locators
    class Link < Base
      def xpath
        super('a')
      end
    end
  end
end