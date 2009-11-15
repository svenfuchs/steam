require 'core_ext/ruby/array/flatten_once'
require 'core_ext/ruby/kernel/silence_warnings'
require 'core_ext/ruby/string/camelize'
require 'nokogiri'

module Steam
  module Locators
    class Base
      attr_reader :dom, :scope, :selector, :attributes

      def initialize(dom, *args)
        @dom        = dom
        @attributes = args.last.is_a?(Hash) ? args.pop : {}
        @selector   = args.pop
        @scope      = @attributes.delete(:scope)

        # for some reason, when we don't scope to //body, nokogiri crashes
        # with an "invalid memory access to location 0x0" error
        @scope ||= selector.to_s == 'body' ? '' : '//body'
      end

      def matchable_attributes
        [:id, :title]
      end

      def xpath(type)
        attribute_pairs.map { |pair| "#{scope}//#{type}" + pair }.join('|')
      end

      def attribute_pairs
        arrays = attributes.select { |name, value| value.is_a?(Array) }
        values = attributes.select { |name, value| !value.is_a?(Array) }

        pairs = values.empty? ? '' : values.inject('') do |pairs, (name, value)|
          pairs << "[contains(@#{name}, \"#{value}\")]"
        end

        arrays.inject([pairs]) do |pairs, (name, values)|
          values.inject(pairs) do |pairs, (name, value)|
            pairs.map! { |pair| pair << "[contains(@#{name}, \"#{value}\")]" }
          end
        end
      end

      def locate
        case selector
        when String, Regexp
          selected = elements_with_matching_values
          select_by_min_matching_attribute(selected)
        else
          elements.first
        end
      end

      def elements
        dom.elements_by_xpath(xpath)
      end

      def select_by_min_matching_attribute(elements)
        selected = elements.min do |(lft_element, lft_value), (rgt_element, rgt_value)|
          compare_by_value(lft_value, rgt_value) ||
          compare_by_hierarchy(lft_element, rgt_element) || 0
        end
        selected && selected[0]
      end

      def compare_by_value(lft, rgt)
        result = lft.length <=> rgt.length
        result != 0 && result
      end

      def compare_by_hierarchy(lft, rgt)
        lft.ancestor_of?(rgt) && 1 || rgt.ancestor_of?(lft) && -1
      end

      def elements_with_matching_values
        elements.map do |element|
          values  = matchable_values(element)
          matcher = regexp(selector)
          values.map { |value| value =~ matcher && [element, value] }.compact
        end.flatten_once
      end

      def matchable_values(element)
        values = matchable_attributes.map { |name| element.attribute(name.to_s).to_s }
        values << element.inner_html
        values.select { |value| value && !value.empty? }
      end

      def regexp(selector)
        selector.is_a?(Regexp) ? selector : /#{Regexp.escape(selector.to_s)}/i
      end
    end
  end
end
