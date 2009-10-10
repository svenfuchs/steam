require 'rubygems'
require 'rjb'

class_path = Dir[File.expand_path(File.dirname(__FILE__) + '/../../lib/htmlunit') + '/*.jar'].join(':')
Rjb::load(class_path)


# klass = Rjb::import('java.lang.String')
Arrays = Rjb::import('java.util.Arrays')
InputStream = Rjb::import('java.io.InputStream')
WebResponseData = Rjb::import('com.gargoylesoftware.htmlunit.WebResponseData')

WebResponseData.getConstructors.each do |method|
  # method.getParameterTypes.map { |type| p type._classname }
  params = method.getParameterTypes.map { |type| type.getName }.join(', ')
  puts "#{method.getName}(#{params})"
end

headers = Arrays.asList([])

# JString = Rjb::import('java.lang.String')
# p JString.new_with_sig('Ljava.lang.String;', "foo")._classname

signature = 'Ljava.io.InputStream;Int;Ljava.lang.String;Ljava.util.List;'
WebResponseData.new_with_sig(signature, nil, 1, "", headers)

# signature = '[B'
# klass.new_with_sig(klass.new("foo"))
# String(byte[] bytes)