module Steam
  class NotFoundError < StandardError
    def initialize(type, attributes=[])
      super "could not find #{type.to_s.scan(/\w+$/)}: \"#{attributes.first}\""
    end
  end
end