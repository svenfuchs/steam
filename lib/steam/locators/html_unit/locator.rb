require 'core_ext/ruby/array/flatten_once'
require 'core_ext/ruby/kernel/silence_warnings'
require 'core_ext/ruby/string/camelize'

module Steam
  module Locators
    module HtmlUnit
      class Locator
        attr_reader :dom, :scope, :selector, :attributes

        def initialize(dom, *args)
          @dom        = dom
          @attributes = args.last.is_a?(Hash) ? args.pop : {}
          @selector   = args.pop
          @scope      = @attributes.delete(:scope)
        end

        def matchable_attributes
          [:id, :title]
        end

        def xpath(type)
          "#{scope}//#{type}" + attributes.map do |name, value| 
            "[contains(@#{name}, \"#{value}\")]"
          end.join

          # return "#{scope}//#{type}" if attributes.empty?
          # attributes.map do |name, values|
          #   Array(values).map { |value| %(#{scope}//#{type}[@#{name}="#{value}"]) }
          # end.join('|')
        end

        def locate
          case selector
          when String
            selected = elements_with_matching_values(selector)
            select_by_min_matching_attribute(selected)
          else
            elements.first
          end
        end

        def elements
          elements = dom.getByXPath(xpath)
          silence_warnings { elements.toArray }
        end

        def select_by_min_matching_attribute(elements)
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

        def elements_with_matching_values(selector)
          elements.map do |element|
            values  = matchable_values(element)
            matcher = regexp(selector)
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

        def regexp(selector)
          selector.is_a?(Regexp) ? selector : /#{Regexp.escape(selector.to_s)}/i
        end
      end
    end
  end
end