require 'rubygems'
require 'core_ext/ruby/kernel/silence_warnings'

module Steam
  module Browser
    class HtmlUnit # < Base
      include Steam::Browser::Locators::HtmlUnit

      attr_accessor :ui, :page, :connection, :cache, :response

      Java.import 'com.gargoylesoftware.htmlunit.WebClient'
      Java.import 'com.gargoylesoftware.htmlunit.FailingHttpStatusCodeException'

      class Cache
        def elements
          @elements ||= {}
        end

        def clear
          @elements.clear
        end
      end

      def initialize(connection, options = {})
        default_options = { :css => true, :javascript => true }
        options = default_options.merge(options)

        @connection = Connection::HtmlUnit.new(connection)
        @cache = Cache.new

        @ui = Java::WebClient.new
        @ui.setCssEnabled(options[:css])
        @ui.setJavaScriptEnabled(options[:javascript])
        @ui.setPrintContentOnFailingStatusCode(false)
        @ui.setThrowExceptionOnFailingStatusCode(false)
        # @ui.setHTMLParserListener(nil); # doesn't work
        @ui.setWebConnection(Rjb::bind(@connection, 'com.gargoylesoftware.htmlunit.WebConnection'))
      end

      def call(env)
        request = Rack::Request.new(env)
        @page = ui.getPage(request.url)
        respond
      end

      def click_link(text_or_title_or_id, options = {})
        @page = find_link(text_or_title_or_id).click
        respond
      end

      def click_button(value = nil)
        @page = find_button(value).click
        respond
      end

      def submit_form(id)
        @page = find_form(id).submit(nil)
        respond
      end

      def fill_in(value, options = {})
        field = find_field(value, 'text', 'textarea', 'password')
        # field.raise_error_if_disabled # TODO
        method = field._classname.include?('HtmlTextArea') ? :setText : :setValueAttribute
        @page = field.send(method, options[:with])
        respond
      end

      def check(value)
        field = find_field(value, 'checkbox')
        @page = field.setChecked(true)
        respond
      end

      def uncheck(value)
        field = find_field(value, 'checkbox')
        @page = field.setChecked(false)
        respond
      end

      def choose(value)
        field = find_field(value, 'radio')
        @page = field.setChecked(true)
        respond
      end

      def select(option, options = {})
        field = find_select_option(option, options[:from])
        @page = field.setSelected(true)
        respond
      end

      def drag_and_drop(drag, options = {})
        drag = find_element(drag)
        drop = find_element(options[:to])
        drag.mouseDown
        drop.mouseMove
        yield(drag, drop) if block_given?
        @page = drop.mouseUp
        respond
      end

      protected

        def dom
          # @dom ||=
          Webrat::XML.xml_document(response.body.join)
        end

        def respond
          @dom = nil
          status = @page.getWebResponse.getStatusCode
          headers = @page.getWebResponse.getResponseHeaders.toArray.inject({}) do |headers, pair|
            headers[pair.name] = pair.value
            headers
          end
          @response = Rack::Response.new(@page.asXml, status, headers)
          @response.to_a
        end
    end
  end
end

# require "webrat/core/locators/locator"
# 
# module Webrat
#   module Locators
#     class FormLocator < Locator
#       def locate
#         Form.load(@session, form_element)
#       end
# 
#       def form_element
#         Webrat::XML.css_at(@dom, "#" + @value)
#       end
#     end
#   end
# end

