require 'rubygems'
require 'rjb'

class_path = Dir[File.expand_path(File.dirname(__FILE__) + '/../../lib/htmlunit') + '/*.jar'].join(':')
Rjb::load(class_path)


# klass = Rjb::import('java.lang.String')
Arrays = Rjb::import('java.util.Arrays')
WebResponseData = Rjb::import('com.gargoylesoftware.htmlunit.WebResponseData')

# WebResponseData.getConstructors.each do |method|
#   params = method.getParameterTypes.map { |type| type.getName }.join(', ')
#   puts "#{method.getName}(#{params})"
# end

headers = Arrays.asList([])

# com.gargoylesoftware.htmlunit.WebResponseData([B, int, java.lang.String, java.util.List)
signature = '[B;I;Ljava.lang.String;Ljava.util.List;'
WebResponseData.new_with_sig(signature, 'foo'.split(/./), 1, "", headers)
