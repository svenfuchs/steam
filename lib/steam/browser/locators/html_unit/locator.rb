require 'core_ext/ruby/array/flatten_once'
require 'core_ext/ruby/kernel/silence_warnings'
require 'core_ext/ruby/string/camelize'

module Steam
  module Browser
    module Locators
      module HtmlUnit
        class Locator
          attr_reader :page, :attributes
          
          def initialize(page, attributes = {})
            @page = page
            @attributes = attributes
          end
          
          def matchable_attributes
            [:id, :title]
          end

          def xpath(type)
            return "//#{type}" if attributes.empty?

            attributes.map do |name, values| 
              Array(values).map { |value| %(//#{type}[@#{name}="#{value}"]) }
            end.join('|')
          end
          
          def locate(value = nil)
            return elements[0] unless value

            selected = elements_with_matching_values(value)
            select_by_min_matching_attribute(selected, value)
          end
          
          def elements
            elements = page.getByXPath(xpath)
            silence_warnings { elements.toArray }
          end

          def select_by_min_matching_attribute(elements, value)
            selected = elements.min do |(lft_element, lft_value), (rgt_element, rgt_value)|
              compare_by_value(lft_value, rgt_value) || 
              compare_by_hierarchie(lft_element, rgt_element) || 0
            end
            selected && selected[0]
          end
          
          def compare_by_value(lft, rgt)
            result = lft.length <=> rgt.length
            result != 0 && result
          end
          
          def compare_by_hierarchie(lft, rgt)
            lft.isAncestorOf(rgt) && 1 || rgt.isAncestorOf(lft) && -1
          end
          
          def elements_with_matching_values(matcher)
            elements.map do |element|
              values  = matchable_values(element)
              matcher = regexp(matcher)
              values.map { |value| value =~ matcher && [element, value] }.compact
            end.flatten_once
          end
          
          def matchable_attribute_methods
            matchable_attributes.map do |attribute| 
              "get#{attribute.to_s.camelize}Attribute"
            end
          end
          
          def matchable_values(element)
            methods = matchable_attribute_methods + [:asText]
            values = methods.map { |method| element.send(method) rescue nil }
            values.select { |value| value && !value.empty? }
          end
          
          def regexp(value)
            value.is_a?(Regexp) ? value : /#{Regexp.escape(value.to_s)}/i
          end
        end
      end
    end
  end
end