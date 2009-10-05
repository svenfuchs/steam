require 'core_ext/ruby/string/underscore'

module Steam
  module Browser
    module Locators
      module HtmlUnit
        autoload :AreaLocator,         'steam/browser/locators/html_unit/area_locator'
        autoload :ButtonLocator,       'steam/browser/locators/html_unit/button_locator'
        autoload :ElementLocator,      'steam/browser/locators/html_unit/element_locator'
        autoload :FieldLocator,        'steam/browser/locators/html_unit/field_locator'
        autoload :FormLocator,         'steam/browser/locators/html_unit/form_locator'
        autoload :Locator,             'steam/browser/locators/html_unit/locator'
        autoload :LabelLocator,        'steam/browser/locators/html_unit/label_locator'
        autoload :LinkLocator,         'steam/browser/locators/html_unit/link_locator'
        autoload :SelectLocator,       'steam/browser/locators/html_unit/select_locator'
        autoload :SelectOptionLocator, 'steam/browser/locators/html_unit/select_option_locator'
        autoload :TextAreaLocator,     'steam/browser/locators/html_unit/text_area_locator'

        def current_scope
          scopes.last
        end

        def scopes
          @scopes ||= ['']
        end

        def within(element)
          element = find_element(element) unless element.respond_to?(:_classname)
          scopes.push(element.getCanonicalXPath)
          result = yield
          scopes.pop
          result
        end

        def click_link(selector, options = {})
          @page = find_link(selector).click
          respond
        end

        def click_button(selector = nil)
          @page = find_button(selector).click
          respond
        end

        def submit_form(selector)
          @page = find_form(selector).submit(nil)
          respond
        end

        def fill_in(selector, options = {})
          field = find_field(selector, :type => %w(text textarea password))
          # field.raise_error_if_disabled # TODO
          method = field._classname.include?('HtmlTextArea') ? :setText : :setValueAttribute
          @page = field.send(method, options[:with])
          respond
        end

        def set_hidden_field(selector, options = {})
          field = locate_field(selector, 'hidden')
          field.setValueAttribute(options[:to])
        end

        def check(selector)
          field = find_field(selector, :type => 'checkbox')
          @page = field.setChecked(true)
          respond
        end

        def uncheck(selector)
          field = find_field(selector, :type => 'checkbox')
          @page = field.setChecked(false)
          respond
        end

        def choose(selector)
          field = find_field(selector, :type => 'radio')
          @page = field.setChecked(true)
          respond
        end

        def select(selector, options = {})
          field = find_select_option(selector, options)
          @page = field.setSelected(true)
          respond
        end

        def click_area(selector)
          find_area(selector).click
        end

        def drag_and_drop(selector, options = {})
          drag = find_element(selector)
          drop = find_element(options[:to])
          drag.mouseDown
          drop.mouseMove
          yield(drag, drop) if block_given?
          @page = drop.mouseUp
          respond
        end

        protected

          def locators
            @locators ||= Hash[*HtmlUnit.constants.map do |name|
              [name.underscore.gsub('_locator', ''), HtmlUnit.const_get(name)]
            end.flatten]
          end

          def locate(type, *args)
            selector = args.shift
            options  = args.last.is_a?(Hash) ? args.pop : {}
            scope    = options.delete(:from) || options.delete(:within)
            locator  = lambda { type.new(page, current_scope, *args << options).locate(selector) }

            scope ? within(scope) { locator.call } : locator.call
          end

          def find_select_option(selector, options = {})
            from = options.delete(:from) or raise "no select specified (use :from)"
            select = find_select(from)
            within(select) { locate(SelectOptionLocator, selector, options) }
          end

          def method_missing(method, *args)
            return super unless method.to_s =~ /^find_(.*)/
            locate(locators[$1], *args)
          end
      end
    end
  end
end
