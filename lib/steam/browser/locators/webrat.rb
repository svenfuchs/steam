require "webrat/core/locators"

module Steam
  module Browser
    module Locators
      module Webrat
        include ::Webrat
        include ::Webrat::Locators

        def find_element(text_or_id)
          element = ElementLocator.new(cache, dom, text_or_id).locate
          @page.getByXPath(element.path).get(0)
        end

        def find_link(text_or_title_or_id)
          element = LinkLocator.new(cache, dom, text_or_title_or_id).locate!
          @page.getByXPath(element.path).get(0)
        end

        def find_button(value)
          element = ButtonLocator.new(cache, dom, value).locate!
          @page.getByXPath(element.path).get(0)
        end

        # def find_form(name_or_id)
        #   element = FormLocator.new(cache, dom, name_or_id).locate!
        #   @page.getByXPath(element.path).get(0)
        # end

        def find_field(value, *types)
          element = FieldLocator.new(cache, dom, value, *types).locate!
          elements = @page.getByXPath(element.path)
          silence_warnings { elements.get(0) } # FIXME why the heck does this issue tons of warnings
        end

        def find_select_option(value, id_or_name_or_label = nil)
          element = SelectOptionLocator.new(cache, dom, value, id_or_name_or_label).locate!
          @page.getByXPath(element.path).get(0)
        end

        class ElementLocator < Locator
          def locate
            Webrat::Element.load(@session, element)
          end

          def element
            matching_elements.min { |a, b|
              Webrat::XML.all_inner_text(a).length <=> Webrat::XML.all_inner_text(b).length
            }
          end

          def matching_elements
            @matching_elements ||= elements.select do |element|
              # matches_text?(element) ||
              matches_id?(element)
            end
          end

          def matches_text?(element)
            if @value.is_a?(Regexp)
              matcher = @value
            else
              matcher = /#{Regexp.escape(@value.to_s)}/i
            end

            replace_nbsp(Webrat::XML.all_inner_text(element)) =~ matcher ||
            replace_nbsp_ref(Webrat::XML.inner_html(element)) =~ matcher
          end

          def matches_id?(element)
            if @value.is_a?(Regexp)
              (Webrat::XML.attribute(element, "id") =~ @value) ? true : false
            else
              (Webrat::XML.attribute(element, "id") == @value) ? true : false
            end
          end

          def elements
            Webrat::XML.xpath_search(@dom, '//*')
          end

          def replace_nbsp(str)
            if str.respond_to?(:valid_encoding?)
              if str.valid_encoding?
                str.gsub(/\xc2\xa0/u, ' ')
              else
                str.force_encoding('UTF-8').gsub(/\xc2\xa0/u, ' ')
              end
            elsif str
              str.gsub(/\xc2\xa0/u, ' ')
            else
              str
            end
          end

          def replace_nbsp_ref(str)
            str.gsub('&#xA0;',' ').gsub('&nbsp;', ' ')
          end

          def error_message
            "Could not find element with text or id #{@value.inspect}"
          end

        end
      end
    end
  end
end
