require 'drb'

module Steam
  module Browser
    class HtmlUnit
      module Drb
        class Client
          def initialize
            DRb.start_service
            @browser = DRbObject.new(nil, Service.uri)
          end
          
          def method_missing(method, *args, &block)
            return @browser.send(method, *args, &block) # if @browser.respond_to?(method)
          end
        end
      end
    end
  end
end