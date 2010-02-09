# Not sure about this. The only reason why this class is needed is that 
# Rack::Response#body returns an Array of body parts while in Rails integration
# tests response.body returns a String.

require 'uri'

module Steam
  class Response < Rack::Response
    def body
      super.join
    end
  end
end