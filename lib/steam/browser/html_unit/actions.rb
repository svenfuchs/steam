module Steam
  module Browser
    class HtmlUnit
      module Actions
        def click_link(selector, options = {})
          element = locate_link(selector)
          @page = page.getFirstByXPath(element.xpath).click
          respond!
        end
    
        def click_button(selector = nil)
          element = locate_button(selector)
          @page = page.getFirstByXPath(element.xpath).click
          respond!
        end
    
        def submit_form(selector)
          element = locate_form(selector)
          @page = page.getFirstByXPath(element.xpath).submit(nil)
          respond!
        end
    
        def fill_in(selector, options = {})
          element = locate_field(selector, :type => %w(text textarea password))
          # element.raise_error_if_disabled # TODO
          method = element.tag_name == 'text_area' ? :setText : :setValueAttribute
          field = silence_warnings { page.getFirstByXPath(element.xpath) }
          @page = field.send(method, options[:with])
          respond!
        end
    
        def set_hidden_field(selector, options = {})
          element = locate_field(selector, 'hidden')
          @page = page.getFirstByXPath(element.xpath).setValueAttribute(options[:to])
        end
    
        def check(selector)
          element = locate_field(selector, :type => 'checkbox')
          @page = page.getFirstByXPath(element.xpath).setChecked(true)
          respond!
        end
    
        def uncheck(selector)
          element = locate_field(selector, :type => 'checkbox')
          @page = page.getFirstByXPath(element.xpath).setChecked(false)
          respond!
        end
    
        def choose(selector)
          element = locate_field(selector, :type => 'radio')
          @page = page.getFirstByXPath(element.xpath).setChecked(true)
          respond!
        end
    
        def select(selector, options = {})
          element = locate_select_option(selector, options)
          @page = page.getFirstByXPath(element.xpath).setSelected(true)
          respond!
        end
    
        def click_area(selector)
          element = locate_area(selector)
          @page = page.getFirstByXPath(element.xpath).click
          respond!
        end
    
        def drag(element)
          element = locate_element(element) unless element.respond_to?(:xpath)
          @page = page.getFirstByXPath(element.xpath).mouseDown
          respond!
        end
    
        def drop(element)
          element = locate_element(element) unless element.respond_to?(:xpath)
          element = page.getFirstByXPath(element.xpath)
          element.mouseMove
          @page = element.mouseUp
          respond!
        end
      end
    end
  end
end