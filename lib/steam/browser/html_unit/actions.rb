require 'core_ext/ruby/hash/slice'
require 'core_ext/ruby/kernel/silence_warnings'

module Steam
  module Browser
    class HtmlUnit
      module Actions
        def click_on(*args)
          action { locate(*args).click }
        end

        def click_link(element, options = {})
          action { locate(:link, element, options).click }
        end
        
        def click_button(element, options = {})
          action { locate(:button, element, options).click }
        end
        
        def click_area(element, options = {})
          action { locate(:area, element, options).click }
        end
        
        def fill_in(element, options = {})
          action do
            value = options.delete(:with)
            element = locate(:field, element, options)
            result = element.setText(value) rescue element.setValueAttribute(value)
            # TODO - submit a bug: element.setText returns nil, textarea.setValueAttribute returns a page
            result || page
          end
        end
        
        def check(element, options = {})
          action { locate(:check_box, element, options).setChecked(true) }
        end
        
        def uncheck(element, options = {})
          action { locate(:check_box, element, options).setChecked(false) }
        end
        
        def choose(element, options = {})
          action { locate(:radio_button, element, options).setChecked(true) }
        end
        
        def select(element, options = {})
          options.update(:within => [:select, options.delete(:from)])
          action { locate(:select_option, element, options).setSelected(true) }
        end
        
        def set_hidden_field(element, options = {})
          action do
            value = options.delete(:to)
            locate(:hidden_field, element, options).setValueAttribute(value)
          end
        end
        
        # TODO implement a way to supply content_type
        def attach_file(element, path, options = {})
          fill_in(element, options.merge(:with => path))
        end
        
        def submit_form(element, options = {})
          action { locate(:form, element, options).submit(nil) }
        end
        
        def drag_and_drop(element, options = {})
          drag(element, options)
          drop
        end
        
        def drag(element, options = {})
          action do
            target  = extract_drop_target!(options, [:to, :onto, :over, :target])
            element = locate(element, options)
            if target
              element.mouseDown
              @_drop_target = locate(target)
              @_drop_target.mouseMove
            else
              element.mouseDown
            end
          end
        end
        
        def drop(element = nil, options = {})
          action do
            element = @_drop_target || locate(element, options)
            element.mouseMove unless @_drop_target
            @_drop_target = nil
            element.mouseUp
          end
        end
        
        def hover(element, options = {})
          action { locate(element, options).mouseOver }
        end
        
        def blur(element, options = {})
          action do
            locate(element, options).blur
            @page # blur seems to return nil
          end
        end
        
        def focus(element, options = {})
          action do
            locate(element, options).focus
            @page # focus seems to return nil
          end
        end
        
        def double_click(element, options = {})
          action { locate(element, options).dblClick }
        end
        
        # Rails specific actions
        DATE_TIME_CODE = {
          :year   => '1i',
          :month  => '2i',
          :day    => '3i',
          :hour   => '4i',
          :minute => '5i',
          :second => '6i'
        }
        
        def select_date(date, options = {})
          date = date.respond_to?(:strftime) ? date : Date.parse(date)
          prefix = locate_id_prefix(options)
        
          # FIXME .to_s chould be done somewhere inside the locator
          select(date.year.to_s,      :from => "#{prefix}_#{DATE_TIME_CODE[:year]}")
          select(date.strftime('%B'), :from => "#{prefix}_#{DATE_TIME_CODE[:month]}")
          select(date.day.to_s,       :from => "#{prefix}_#{DATE_TIME_CODE[:day]}")
        end
        
        def select_datetime(datetime, options = {})
          select_date(datetime)
          select_time(datetime)
        end
        
        def select_time(time, options = {})
          time = time.respond_to?(:strftime) ? time : DateTime.parse(time)
          prefix = locate_id_prefix(options)
        
          select(time.hour.to_s.rjust(2,'0'), :from => "#{prefix}_#{DATE_TIME_CODE[:hour]}")
          select(time.min.to_s.rjust(2,'0'),  :from => "#{prefix}_#{DATE_TIME_CODE[:minute]}")
          # second?
        end
        
        protected
        
          # inspired by Webrat
          def locate_id_prefix(options)
            options[:id_prefix] ? options[:id_prefix] : locate_id_prefix_label(options).attribute('for')
          end
          
          def locate_id_prefix_label(options)
            locate(:label, options[:from]) rescue locate(:label, :for => options[:from])
          end
        
          def extract_drop_target!(targets, keys)
            rest   = targets.slice!(*keys)
            target = targets.values.compact.first
            targets.replace(rest)
            target
          end
      end
    end
  end
end
