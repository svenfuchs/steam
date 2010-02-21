# We currently only implement HtmlUnit as a browser. Maybe at some point
# Webdriver might be an interesting alternative.

require 'core_ext/ruby/string/camelize'

module Steam
  module Browser
    autoload :HtmlUnit, 'steam/browser/html_unit'
    
    class << self
      def create(*args)
        options    = args.last.is_a?(Hash) ? args.pop : {}
        type       = args.shift if args.first.is_a?(Symbol)
        connection = args.pop
        
        type ||= :html_unit
        type = const_get(type.to_s.camelize)
        type = type.const_get('Drb') if options[:daemon]

        type.new(connection, :daemon => true)
      end
    end
  end
end