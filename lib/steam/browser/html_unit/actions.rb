module Steam
  module Browser
    class HtmlUnit
      module Actions
        def click_on(element, options = {})
          action { locate_first_element(element, options).click }
        end

        def click_link(element, options = {})
          action { locate_first_link(element).click }
        end

        def click_button(element, options = {})
          action { locate_first_button(element, options).click }
        end

        def submit_form(element, options = {})
          action { locate_first_form(element, options).submit(nil) }
        end

        def fill_in(element, options = {})
          action do
            value = options.delete(:with)
            # TODO remove silence_warnings
            silence_warnings { element = locate_first_field(element, options) }

            # weird - setText returns nil, setValueAttribute returns a page
            element.getNodeName == 'textarea' ? element.setText(value) : element.setValueAttribute(value)
          end
        end

        def set_hidden_field(element, options = {})
          action do
            value = options.delete(:to)
            locate_first_field(element, options.merge(:type => 'hidden')).setValueAttribute(value)
          end
        end

        def check(element, options = {})
          action { locate_first_field(element, options.merge(:type => 'checkbox')).setChecked(true) }
        end

        def uncheck(element, options = {})
          action { locate_first_field(element, options.merge(:type => 'checkbox')).setChecked(false) }
        end

        def choose(element, options = {})
          action { locate_first_field(element, options.merge(:type => 'radio')).setChecked(true) }
        end

        def select(element, options = {})
          action do
            # FIXME
            unless options[:from].respond_to?(:xpath)
              locate_select(options[:from]) { locate_first_select_option(element).setSelected(true) }
            else
              within(options[:from]) { locate_first_select_option(element).setSelected(true) }
            end
          end
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
            @_drop_target = nil
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

        # Rails specific actions
        DATE_TIME_SUFFIXES = {
          :year   => '1i',
          :month  => '2i',
          :day    => '3i',
          :hour   => '4i',
          :minute => '5i',
          :second => '6i'
        }

        def select_date(date, options = {})
          date = date.respond_to?(:strftime) ? date : Date.parse(date)

          id_prefix   = options.delete(:id_prefix)
          id_prefix ||= options[:from] # FIXME adapt webrat

          # FIXME .to_s should be done somewhere inside the locator
          select(date.year.to_s, :from => "#{id_prefix}_#{DATE_TIME_SUFFIXES[:year]}")
          select(date.mon.to_s,  :from => "#{id_prefix}_#{DATE_TIME_SUFFIXES[:month]}")
          select(date.day.to_s,  :from => "#{id_prefix}_#{DATE_TIME_SUFFIXES[:day]}")
        end

        def select_datetime(datetime, options = {})
          select_date(datetime)
          select_time(datetime)
        end

        def select_time(time, options = {})
          time = time.respond_to?(:strftime) ? time : DateTime.parse(time)

          id_prefix   = options.delete(:id_prefix)
          id_prefix ||= options[:from] # FIXME adapt webrat

          select(time.hour.to_s.rjust(2,'0'), :from => "#{id_prefix}_#{DATE_TIME_SUFFIXES[:hour]}")
          select(time.min.to_s.rjust(2,'0'),  :from => "#{id_prefix}_#{DATE_TIME_SUFFIXES[:minute]}")
          # second?
        end

        def respond_to?(method)
          return true if method.to_s =~ /^locate_first_(.*)$/
          super
        end

        def method_missing(method, *args, &block)
          method_name = method.to_s

          if method_name =~ /^locate_first_(.*)$/
            # TODO define this method when it's first called?
            element = args.shift
            element = send(:"locate_#{$1}", element, *args, &block) unless element.respond_to?(:xpath)
            page.getFirstByXPath(element.xpath)
          else
            super
          end
        end

        protected

          def action
            @page = (page = yield) ? page : @page # some actions return nil
            respond!
          end
      end
    end
  end
end
