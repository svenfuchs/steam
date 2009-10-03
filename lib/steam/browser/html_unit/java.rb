module Steam
  module Browser
    class HtmlUnit
      module Java
        class << self
          def const_missing(name)
            return init && const_get(name) unless @initialized
            super
          end

          protected
          
            def init
              set_classpath!
              import_classes!
              @initialized = true
            end
          
            def set_classpath!
              path = File.expand_path(File.dirname(__FILE__) + "/../../../htmlunit/")
              Rjb::load(Dir["#{path}/*.jar"].join(':'))
            end
          
            def import_classes!
              import('java.net.URL', :Url)
              import('com.gargoylesoftware.htmlunit.MockWebConnection')
              import('com.gargoylesoftware.htmlunit.WebClient')
            end

            def import(signature, name = nil)
              name ||= signature.split('.').last.to_sym
              const_set(name, Rjb::import(signature))
            end
        end
      end
    end
  end
end