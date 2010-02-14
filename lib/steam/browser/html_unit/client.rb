# Just hides the ugly Java'ish details of instantiating, configuring and using
# a com.gargoylesoftware.htmlunit.WebClient (HtmlUnit's main browser object).

module Steam
  module Browser
    class HtmlUnit
      Java.load(Dir["#{Steam.config[:html_unit][:java_path]}/*.jar"].join(':'))

      Java.import 'com.gargoylesoftware.htmlunit.Version', :HtmlUnitVersion
      Java.import 'com.gargoylesoftware.htmlunit.WebClient'
      Java.import 'com.gargoylesoftware.htmlunit.BrowserVersion'
      Java.import 'com.gargoylesoftware.htmlunit.NicelyResynchronizingAjaxController'
      Java.import 'com.gargoylesoftware.htmlunit.FailingHttpStatusCodeException'

      VERSION = Java::HtmlUnitVersion.getProductVersion

      classifier = VERSION == '2.6' ?
        'org.apache.commons.httpclient.NameValuePair' :    # HtmlUnit 2.6
        'com.gargoylesoftware.htmlunit.util.NameValuePair' # HtmlUnit 2.7
      Java.import(classifier, :NameValuePair)

      class Client
        class SilencingListener
          def notify(message, origin); end
        end

        def initialize(connection = nil, options = {})
          options = Steam.config[:html_unit].merge(options)

          @java = Java::WebClient.new(Java::BrowserVersion.send(options[:browser_version]))
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
            controller = Java::NicelyResynchronizingAjaxController.new
            @java.setAjaxController(controller)
          end

          if connection
            connection = Rjb::bind(Connection.new(connection), 'com.gargoylesoftware.htmlunit.WebConnection')
            @java.setWebConnection(connection)
          end
        end

        def request(*args)
          @java.getPage(*args) # TODO use WebRequestSettings
        end

        def wait_for_javascript(timeout)
          waitForBackgroundJavaScript(timeout)
          yield if block_given?
        end

        # FIXME setLevel throws "Fail: unknown method name `setLevel'". weird.
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