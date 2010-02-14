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

      def init
        @initialized = true

        import('java.net.URL', :Url)
        import('java.lang.System', :System)
        import('java.util.Arrays', :Arrays)
        import('java.util.ArrayList', :ArrayList)
        import('java.util.logging.Logger', :Logger)
        import('java.util.logging.Level', :LogLevel)
        
        # System.getProperties().put("org.apache.commons.logging.simplelog.defaultlog", "error");
      end

      def load(paths)
        Rjb::load(paths, Steam.config[:java_load_params].to_a)
      end
      
      def logger(classifier)
        Logger.getLogger(classifier)
      end
      
      def log_level(name)
        LogLevel.send(name.to_s.upcase)
      end
    end
  end
end