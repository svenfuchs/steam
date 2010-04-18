# Just hides the ugly Java'ish details of instantiating, configuring and using
# a com.gargoylesoftware.htmlunit.WebClient (HtmlUnit's main browser object).

module Steam
  module Browser
    class HtmlUnit
      class Client
        Java.load_from(Steam.config[:html_unit][:java_path])

        Java.import 'com.gargoylesoftware.htmlunit.Version'
        Java.import 'com.gargoylesoftware.htmlunit.WebClient'
        Java.import 'com.gargoylesoftware.htmlunit.WebRequestSettings'
        Java.import 'com.gargoylesoftware.htmlunit.BrowserVersion'
        Java.import 'com.gargoylesoftware.htmlunit.NicelyResynchronizingAjaxController'
        Java.import 'com.gargoylesoftware.htmlunit.FailingHttpStatusCodeException'
        Java.import 'org.apache.commons.httpclient.Cookie', 'Java::Com::Gargoylesoftware::Htmlunit::Cookie'
        # Java.import 'com.gargoylesoftware.htmlunit.util.Cookie'

        include Java::Com::Gargoylesoftware::Htmlunit

        class SilencingListener
          def notify(message, origin); end
        end

        attr_reader :connection, :handlers

        def initialize(connection = nil, options = {})
          @connection = connection
          @handlers   = {}
          options = Steam.config[:html_unit].merge(options)

          @java = WebClient.new(BrowserVersion.send(options[:browser_version]))
          @java.setCssEnabled(options[:css])
          @java.setJavaScriptEnabled(options[:javascript])
          @java.setPrintContentOnFailingStatusCode(options[:on_error_status] == :print)
          @java.setThrowExceptionOnFailingStatusCode(options[:on_error_status] == :raise)
          @java.setThrowExceptionOnScriptError(options[:on_script_error] == :raise)

          self.log_level = options[:log_level]
          unless options[:log_incorrectness]
            listener = Rjb::bind(SilencingListener.new, 'com.gargoylesoftware.htmlunit.IncorrectnessListener')
            @java.setIncorrectnessListener(listener)
          end

          if options[:resynchronize]
            controller = NicelyResynchronizingAjaxController.new
            @java.setAjaxController(controller)
          end

          if connection
            connection = Rjb::bind(HtmlUnit::Connection.new(connection), 'com.gargoylesoftware.htmlunit.WebConnection')
            @java.setWebConnection(connection)
          end
        end

        def get(request)
          perform(self.request_settings(request))
        end

        def perform(request_settings)
          @java._invoke('getPage', 'Lcom.gargoylesoftware.htmlunit.WebRequestSettings;', request_settings)
        end

        def request_settings(request)
          url      = Java::Net::Url.new(request.url)
          settings = WebRequestSettings.new(url)
          request.headers.each { |name, value| settings.setAdditionalHeader(name.to_s, value.to_s) } if request.headers
          settings
        end

        def wait_for_javascript(timeout)
          waitForBackgroundJavaScript(timeout)
          yield if block_given?
        end

        def set_handler(type, &block)
          @java.send(:"set#{type.to_s.camelize}Handler", Handler.create(type, block))
        end

        def remove_handler(type)
          @java.send(:"set#{type.to_s.camelize}Handler", nil)
        end

        def get_cookie(name)
          cookie = @java.getCookieManager.getCookie(name)
          cookie ? cookie.getValue : nil
        end

        def add_cookie(name, value) # TODO what about domain, path, expires etc?
          cookie = Cookie.new
          cookie.setName(name)
          cookie.setValue(value)
          @java.getCookieManager.addCookie(cookie)
        end

        def clear_cookies
          @java.getCookieManager.clearCookies
        end

        def log_level=(level)
          [ 'com.gargoylesoftware.htmlunit',
            'com.gargoylesoftware.htmlunit.html',
            'com.gargoylesoftware.htmlunit.javascript',
            'org.apache.commons.httpclient'
          ].each { |classifier|
            Java.logger(classifier).setLevel(Java.log_level(level)) }
        end

        def method_missing(method, *args)
          @java.send(method, *args)
        end
      end
    end
  end
end