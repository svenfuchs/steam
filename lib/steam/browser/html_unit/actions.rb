module Steam
  module Browser
    class HtmlUnit
      module Actions
        def click_on(element, *args)
          element = locate_element(element, *args) unless element.respond_to?(:xpath)
          @page = page.getFirstByXPath(element.xpath).click
          respond!
        end

        def click_link(element, options = {})
          element = locate_link(element) unless element.respond_to?(:xpath)
          @page = page.getFirstByXPath(element.xpath).click
          respond!
        end

        def click_button(element = nil)
          element = locate_button(element) unless element.respond_to?(:xpath)
          @page = page.getFirstByXPath(element.xpath).click
          respond!
        end

        def submit_form(element)
          element = locate_form(element) unless element.respond_to?(:xpath)
          @page = page.getFirstByXPath(element.xpath).submit(nil)
          respond!
        end

        def fill_in(element, options = {})
          element = locate_field(element, :type => %w(text textarea password)) unless element.respond_to?(:xpath)
          # element.raise_error_if_disabled # TODO
          method = element.tag_name == 'text_area' ? :setText : :setValueAttribute
          field = silence_warnings { page.getFirstByXPath(element.xpath) }
          @page = field.send(method, options[:with].to_s)
          respond!
        end

        def set_hidden_field(element, options = {})
          element = locate_field(element, 'hidden') unless element.respond_to?(:xpath)
          @page = page.getFirstByXPath(element.xpath).setValueAttribute(options[:to])
        end

        def check(element)
          element = locate_field(element, :type => 'checkbox') unless element.respond_to?(:xpath)
          @page = page.getFirstByXPath(element.xpath).setChecked(true)
          respond!
        end

        def uncheck(element)
          element = locate_field(element, :type => 'checkbox') unless element.respond_to?(:xpath)
          @page = page.getFirstByXPath(element.xpath).setChecked(false)
          respond!
        end

        def choose(element)
          element = locate_field(element, :type => 'radio') unless element.respond_to?(:xpath)
          @page = page.getFirstByXPath(element.xpath).setChecked(true)
          respond!
        end

        def select(element, options = {})
          element = locate_select_option(element, options) unless element.respond_to?(:xpath)
          @page = page.getFirstByXPath(element.xpath).setSelected(true)
          respond!
        end

        def click_area(element)
          element = locate_area(element) unless element.respond_to?(:xpath)
          @page = page.getFirstByXPath(element.xpath).click
          respond!
        end

        def drag(element, options = {})
          element = locate_element(element) unless element.respond_to?(:xpath)
          @page = page.getFirstByXPath(element.xpath).mouseDown

          if drop_target = options.values_at(:to, :onto, :over, :target).compact.first
            drop(drop_target)
          else
            respond!
          end
        end

        def drop(element)
          element = locate_element(element) unless element.respond_to?(:xpath)
          element = page.getFirstByXPath(element.xpath)
          element.mouseMove
          @page = element.mouseUp
          respond!
        end

        def hover(element, options = {})
          element = locate_element(element) unless element.respond_to?(:xpath)
          element = page.getFirstByXPath(element.xpath)
          element.mouseOver
          respond!
        end

        def blur(element, options = {})
          element = locate_element(element) unless element.respond_to?(:xpath)
          page.getFirstByXPath(element.xpath).blur # blur always returns nil
          respond!
        end

        def focus(element, options = {})
          element = locate_element(element) unless element.respond_to?(:xpath)
          page.getFirstByXPath(element.xpath).focus # focus always returns nil
          respond!
        end

        def double_click(element, options = {})
          element = locate_element(element) unless element.respond_to?(:xpath)
          element = page.getFirstByXPath(element.xpath)
          @page = element.dblClick
          respond!
        end
      end
    end
  end
end
