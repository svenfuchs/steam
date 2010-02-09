require 'rubygems'
require 'rjb'

class_path = Dir[File.expand_path(File.dirname(__FILE__) + '/../../lib/htmlunit') + '/*.jar'].join(':')
Rjb::load(class_path)


klass = Rjb::import('java.lang.String')
klass = Rjb::import('com.gargoylesoftware.htmlunit.WebResponseData')

# methods = klass.getDeclaredMethods
methods = klass.getConstructors

methods.each do |method|
  # method.getParameterTypes.map { |type| p type._classname }
  params = method.getParameterTypes.map { |type| type.getName }.join(', ')
  puts "#{method.getName}(#{params})"
end

signature = '[B'
p klass.new_with_sig(signature, "foo".split(/./))
# String(byte[] bytes)