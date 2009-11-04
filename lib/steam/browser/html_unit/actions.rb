module Steam
  module Browser
    class HtmlUnit
      module Actions
        def click_on(element, options = {})
          @page = locate_first_element(element, options).click
          respond!
        end

        def click_link(element, options = {})
          @page = locate_first_element(element).click
          respond!
        end

        def click_button(element = nil, options = {})
          @page = locate_first_element(element, options).click
          respond!
        end

        def submit_form(element, options = {})
          @page = locate_first_element(element, options).submit(nil)
          respond!
        end

        def fill_in(element, options = {})
          value = options.delete(:with)
          # TODO remove silence_warnings
          silence_warnings { element = locate_first_element(element, options) }

          # weird - setText returns nil, setValueAttribute returns a page
          element.getNodeName == 'textarea' ? element.setText(value) : @page = element.setValueAttribute(value)
          respond!
        end

        def set_hidden_field(element, options = {})
          value = options.delete(:to)
          @page = locate_first_element(element, options.merge(:type => 'hidden')).setValueAttribute(value)
        end

        def check(element, options = {})
          @page = locate_first_element(element, options.merge(:type => 'checkbox')).setChecked(true)
          respond!
        end

        def uncheck(element, options = {})
          @page = locate_first_element(element, options.merge(:type => 'checkbox')).setChecked(false)
          respond!
        end

        def choose(element, options = {})
          @page = locate_first_element(element, options.merge(:type => 'radio')).setChecked(true)
          respond!
        end

        def select(element, options = {})
          @page = locate_first_element(element, options).setSelected(true)
          respond!
        end

        def click_area(element, options = {})
          @page = locate_first_element(element, options).click
          respond!
        end

        def drag(element, options = {})
          # TODO should pass options hash?
          @page = locate_first_element(element).mouseDown

          if drop_target = options.values_at(:to, :onto, :over, :target).compact.first
            drop(drop_target)
          else
            respond!
          end
        end

        def drop(element, options = {})
          element = locate_first_element(element, options)
          @page = element.mouseMove && element.mouseUp
          respond!
        end

        def hover(element, options = {})
          locate_first_element(element, options).mouseOver
          respond!
        end

        def blur(element, options = {})
          locate_first_element(element, options).blur # blur always returns nil
          respond!
        end

        def focus(element, options = {})
          locate_first_element(element, options).focus # focus always returns nil
          respond!
        end

        def double_click(element, options = {})
          @page = locate_first_element(element, options).dblClick
          respond!
        end

        protected

          def locate_first_element(element, options = {})
            element = locate_element(element, options) unless element.respond_to?(:xpath)
            page.getFirstByXPath(element.xpath)
          end
      end
    end
  end
end
