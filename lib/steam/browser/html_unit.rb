require 'rubygems'
require 'rjb'
require 'webrat'
require 'steam/browser/webrat_patches'
require 'core_ext/ruby/kernel/silence_warnings'

module Steam
  module Browser
    class HtmlUnit # < Base
      include Webrat::Locators

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

      def drag_and_drop(drag, options = {})
        drag = find_element(drag)
        drop = find_element(options[:to])
        drag.mouseDown
        drop.mouseMove
        yield(drag, drop) if block_given?
        @page = drop.mouseUp
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
        field = find_field(value, Webrat::TextField, Webrat::TextareaField, Webrat::PasswordField)
        # field.raise_error_if_disabled # TODO
        method = field._classname.include?('HtmlTextArea') ? :setText : :setValueAttribute
        @page = field.send(method, options[:with])
        respond
      end

      def check(value)
        field = find_field(value, Webrat::CheckboxField)
        @page = field.setChecked(true)
        respond
      end

      def uncheck(value)
        field = find_field(value, Webrat::CheckboxField)
        @page = field.setChecked(false)
        respond
      end

      def choose(value)
        field = find_field(value, Webrat::RadioField)
        @page = field.setChecked(true)
        respond
      end

      def select(option, options = {})
        field = find_select_option(option, options[:from])
        @page = field.setSelected(true)
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

        def find_form(id)
          element = FormLocator.new(cache, dom, id).locate!
          @page.getByXPath(element.path).get(0)
        end

        def find_field(value, *types)
          element = FieldLocator.new(cache, dom, value, *types).locate!
          elements = @page.getByXPath(element.path)
          silence_warnings { elements.get(0) } # FIXME why the heck does this issue tons of warnings
        end

        def find_select_option(value, id_or_name_or_label = nil)
          element = SelectOptionLocator.new(cache, dom, value, id_or_name_or_label).locate!
          @page.getByXPath(element.path).get(0)
        end
    end
  end
end

require "webrat/core/locators/locator"

module Webrat
  module Locators
    class ElementLocator < Locator
      def locate
        Element.load(@session, element)
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


