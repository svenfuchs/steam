require 'rubygems'
require 'rjb'
require 'webrat'
require 'steam/browser/webrat_patches'
require 'core_ext/kernel/silence_warnings'

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
          @dom ||= Webrat::XML.xml_document(response.body.join)
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