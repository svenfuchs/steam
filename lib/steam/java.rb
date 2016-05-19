require 'rjb'
require 'core_ext/ruby/string/camelize'
require 'core_ext/ruby/string/underscore'

module Steam
  module Java

    # TODO replace this with http://github.com/sklemm/jrequire/blob/master/lib/java.rb

    module AutoDefine
      def const_set_nested(full_name, const)
        name = pop_name(full_name)
        if full_name.empty? && !const_defined?(name)
          const_set(name, const)
        else
          const_set(name, Module.new { extend AutoDefine }) unless const_defined?(name)
          const_get(name).const_set_nested(full_name, const) unless full_name.empty?
        end
      end

      def pop_name(string)
        name, *rest = string.split('::')
        string.replace(rest.join('::'))
        name
      end
    end
    extend AutoDefine

    class << self
      def const_missing(name)
        return init && const_get(name) unless @initialized
        super
      end

      def import(signature, name = nil)
        name ||= path_to_const_name(signature)
        name.gsub!('Java::', '')
        const_set_nested(name, Rjb::import(signature))
      end

      def path_to_const_name(path)
        path.split('.').map { |token| token.underscore.camelize }.join('::')
      end

      def init
        @initialized = true

        import('java.net.URL', 'Java::Net::Url')
        import('java.lang.System')
        import('java.util.Arrays')
        import('java.util.ArrayList')
        import('java.util.logging.Logger')
        import('java.util.logging.Level')
      end

      def load_from(path)
        paths = Dir["#{Steam.config[:html_unit][:java_path]}/*.jar"]
        load(paths.join(':')) unless paths.empty?
        init
      end

      def load(paths)
        Rjb::load(paths, Steam.config[:java_load_params])
      end

      def logger(classifier)
        Util::Logging::Logger.getLogger(classifier)
      end

      def log_level(name)
        Util::Logging::Level.send(name.to_s.upcase)
      end
    end
  end
end
