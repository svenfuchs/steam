module Steam
  module Browser
    class HtmlUnit
      module Handler
        class << self
          def create(type, proc)
            type    = type.to_s.camelize
            handler = self.const_get(type).new(proc)
            Rjb::bind(handler, "com.gargoylesoftware.htmlunit.#{type}Handler")
          end
        end
        
        class Base
          attr_reader :proc

          def initialize(proc)
            @proc = proc
          end
        end

        class Alert < Base
          def handleAlert(page, message)
            proc.call(page, message)
          end
        end

        class Confirm < Base
          def handleConfirm(page, message)
            result = proc.call(page, message)
            result.nil? || !!result
          end
        end
      end
    end
  end
end