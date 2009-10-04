module Steam
  module Browser
    module Locators
      module HtmlUnit
        class LinkLocator < Locator
          def xpath
            super('a')
          end
        end
      end
    end
  end
end
