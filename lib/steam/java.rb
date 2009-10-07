require 'rjb'

module Steam
  module Java
    class << self
      def const_missing(name)
        return init && const_get(name) unless @initialized
        super
      end

      def import(signature, name = nil)
        init unless @initialized
        name ||= signature.split('.').last.to_sym
        const_set(name, Rjb::import(signature)) unless const_defined?(name)
      end

      protected

        def init
          @initialized = true
          set_classpath!
          import_common!
        end
        
        def import_common!
          import('java.net.URL', :Url)
          import('java.util.Arrays', :Arrays)
          import('org.apache.commons.httpclient.NameValuePair', :NameValuePair)
          import('java.util.ArrayList', :ArrayList)
        end

        def set_classpath!
          path = File.expand_path(File.dirname(__FILE__) + "/../htmlunit/")
          Rjb::load(Dir["#{path}/*.jar"].join(':'), ['-Xmx512M'])
        end
    end
  end
end