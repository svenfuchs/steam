module Steam
  module Browser
    module Locators
      module HtmlUnit
        autoload :ButtonLocator,       'steam/browser/locators/html_unit/button_locator'
        autoload :ElementLocator,      'steam/browser/locators/html_unit/element_locator'
        autoload :FieldLocator,        'steam/browser/locators/html_unit/field_locator'
        autoload :FormLocator,         'steam/browser/locators/html_unit/form_locator'
        autoload :Locator,             'steam/browser/locators/html_unit/locator'
        autoload :LabelLocator,        'steam/browser/locators/html_unit/label_locator'
        autoload :LinkLocator,         'steam/browser/locators/html_unit/link_locator'
        autoload :SelectOptionLocator, 'steam/browser/locators/html_unit/select_option_locator'
        autoload :TextAreaLocator,     'steam/browser/locators/html_unit/text_area_locator'

        def find_element(value, *types)
          ElementLocator.new(page, *types).locate(value)
        end
        
        def find_button(value, *types)
          ButtonLocator.new(page, *types).locate(value)
        end
        
        def find_field(value, *types)
          FieldLocator.new(page, *types).locate(value)
        end
        
        def find_form(value)
          FormLocator.new(page).locate(value)
        end
        
        def find_label(value)
          LabelLocator.new(page).locate(value)
        end
        
        def find_link(value)
          LinkLocator.new(page).locate(value)
        end
        
        def find_select_option(value, options = {})
          SelectOptionLocator.new(page).locate(value)
        end
        
        def find_text_area(value)
          TextAreaLocator.new(page).locate(value)
        end
      end
    end
  end
end
