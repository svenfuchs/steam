module Steam
  module Browser
    class HtmlUnit
      module Actions
        def click_on(element, options = {})
          action { locate_first_element(element, options).click }
        end

        def click_link(element, options = {})
          action { locate_first_element(element).click }
        end

        def click_button(element, options = {})
          action { locate_first_element(element, options).click }
        end

        def submit_form(element, options = {})
          action { locate_first_element(element, options).submit(nil) }
        end

        def fill_in(element, options = {})
          action do
            value = options.delete(:with)
            # TODO remove silence_warnings
            silence_warnings { element = locate_first_element(element, options) }

            # weird - setText returns nil, setValueAttribute returns a page
            element.getNodeName == 'textarea' ? element.setText(value) : element.setValueAttribute(value)
          end
        end

        def set_hidden_field(element, options = {})
          action do
            value = options.delete(:to)
            locate_first_element(element, options.merge(:type => 'hidden')).setValueAttribute(value)
          end
        end

        def check(element, options = {})
          action { locate_first_element(element, options.merge(:type => 'checkbox')).setChecked(true) }
        end

        def uncheck(element, options = {})
          action { locate_first_element(element, options.merge(:type => 'checkbox')).setChecked(false) }
        end

        def choose(element, options = {})
          action { locate_first_element(element, options.merge(:type => 'radio')).setChecked(true) }
        end

        def select(element, options = {})
          action { locate_first_element(element, options).setSelected(true) }
        end

        def click_area(element, options = {})
          action { locate_first_element(element, options).click }
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
          action { (element = locate_first_element(element, options)) && element.mouseMove && element.mouseUp }
        end

        def hover(element, options = {})
          action { locate_first_element(element, options).mouseOver }
        end

        def blur(element, options = {})
          action { locate_first_element(element, options).blur }
        end

        def focus(element, options = {})
          action { locate_first_element(element, options).focus }
        end

        def double_click(element, options = {})
          action { locate_first_element(element, options).dblClick }
        end

        protected

          def action
            new_page = yield
            @page = new_page if new_page # some actions return nil
            respond!
          end

          def locate_first_element(element, options = {})
            element = locate_element(element, options) unless element.respond_to?(:xpath)
            page.getFirstByXPath(element.xpath)
          end
      end
    end
  end
end
