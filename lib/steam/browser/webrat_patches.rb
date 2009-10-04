require 'webrat/core/locators/select_option_locator'

module Webrat
  module Locators
    SelectOptionLocator.class_eval do
      def locate
        if @id_or_name_or_label
          field = FieldLocator.new(@session, @dom, @id_or_name_or_label, SelectField).locate!

          field.options.detect do |o|
            if @option_text.is_a?(Regexp)
              Webrat::XML.inner_html(o.element) =~ @option_text
            else
              Webrat::XML.inner_html(o.element).strip == @option_text.to_s
            end
          end
        else
          option_element = option_elements.detect do |o|
            if @option_text.is_a?(Regexp)
              Webrat::XML.inner_html(o) =~ @option_text
            else
              Webrat::XML.inner_html(o).strip == @option_text.to_s
            end
          end

          SelectOption.load(@session, option_element)
        end
      end
    end
  end
end