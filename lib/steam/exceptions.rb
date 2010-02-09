module Steam
  class ElementNotFound < StandardError
    def initialize(*args)
      super "could not find element: #{args.map { |arg| arg.inspect }.join(', ') }"
    end
  end
end