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

        # TODO implement a way to supply content_type
        def attach_file(element, path, options = {})
          fill_in(element, options.merge(:with => path))
        end

        def click_area(element, options = {})
          action { locate_first_element(element, options).click }
        end

        def drag_and_drop(element, options = {})
          drag(element, options)
          drop
        end

        def drag(element, options = {})
          action do
            element = locate_first_element(element)
            if selector = options.values_at(:to, :onto, :over, :target).compact.first
              element.mouseDown
              @_drop_target = locate_first_element(selector)
              @_drop_target.mouseMove
            else
              element.mouseDown
            end
          end
        end

        def drop(element = nil)
          action do
            element ||= @_drop_target
            element = locate_first_element(element)
            element.mouseMove unless @_drop_target
            element.mouseUp
          end
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
            @page = (page = yield) ? page : @page # some actions return nil
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
