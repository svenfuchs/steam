# module Steam
#   module Browser
#     class Webrat
#       class << self
#         def instance(http = nil)
#           @@instance ||= new(http || Steam::Http::RestClient.new)
#         end
#       end
# 
#       attr_accessor :http, :html
# 
#       def initialize(http)
#         @http = http
#       end
# 
#       def method_missing(method, *args)
#         return http.send(method, *args) if http.respond_to?(method)
#         super
#       end
#     end
#   end
# end