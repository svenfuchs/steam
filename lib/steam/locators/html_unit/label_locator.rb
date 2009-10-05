module Steam
  module Locators
    module HtmlUnit
      class LabelLocator < Locator
        def xpath
          super('label')
        end
      end
    end
  end
end
