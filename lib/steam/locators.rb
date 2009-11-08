require 'core_ext/ruby/string/underscore'

module Steam
  module Locators
    autoload :Area,         'steam/locators/area'
    autoload :Base,         'steam/locators/base'
    autoload :Button,       'steam/locators/button'
    autoload :Element,      'steam/locators/element'
    autoload :Field,        'steam/locators/field'
    autoload :Form,         'steam/locators/form'
    autoload :Label,        'steam/locators/label'
    autoload :Link,         'steam/locators/link'
    autoload :Select,       'steam/locators/select'
    autoload :SelectOption, 'steam/locators/select_option'
    autoload :TextArea,     'steam/locators/text_area'

    @@adapters = {
      :nokogiri => Dom::Nokogiri::Page,
      :html_unit => Dom::HtmlUnit::Page
    }

    class << self
      def strategy
        @@strategy ||= :nokogiri
      end

      def strategy=(strategy)
        @@strategy = strategy
      end

      def adapter(name)
        @@adapters[name || Locators.strategy]
      end
    end

    def current_scope
      scopes.last
    end

    def scopes
      @scopes ||= []
    end

    def within(*args)
      element = args.first.respond_to?(:xpath) ? args.first : locate_element(*args)
      scopes.push(element.xpath)
      result = yield
      scopes.pop
      result
    end

    def respond_to?(method)
      return true if method.to_s =~ /^locate_(#{locators.keys.join('|')})$/
      super
    end

    def method_missing(method, *args, &block)
      return locate(locators[$1.to_sym], *args, &block) if method.to_s =~ /^locate_(#{locators.keys.join('|')})$/
      super
    end

    protected

      def locators
        @locators ||= Hash[*Locators.constants.map do |name|
          [name.underscore.gsub('_locator', '').to_sym, Locators.const_get(name)]
        end.flatten]
      end

      def locate(type, *args, &block)
        attributes = args.last.is_a?(Hash) ? args.last : args.push({}).last
        scope = attributes.delete(:from) || attributes.delete(:within)
        attributes.update(:scope => current_scope) if current_scope

        locator = lambda { locator(type, *args).locate }
        element = scope ? within(scope) { locator.call } : locator.call
        element = within(element) { yield(element) } if element && block_given?
        element
      end

      def locator(type, *args)
        options = args.last.is_a?(Hash) ? args.last : args.push({}).last

        adapter = options.delete(:using)
        dom = Locators.adapter(adapter).build(page, response.body.join)

        type = locators[type.to_sym] if type.is_a?(Symbol)
        type.new(dom, *args)
      end

      # def locate_select_option(selector, options = {})
      #   from = options.delete(:from) or raise "no select specified (use :from)"
      #   select = locate_select(from)
      #   within(select) { locate(SelectOptionLocator, selector, options) }
      # end
  end
end