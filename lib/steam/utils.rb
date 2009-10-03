module Steam
  module Utils
    extend self

    def name_with_prefix(prefix, name)
      prefix ? "#{prefix}[#{name}]" : name.to_s
    end

    def requestify(parameters, prefix=nil)
      # if TestUploadedFile === parameters
      #   raise MultiPartNeededException
      # els
      if Hash === parameters
        return nil if parameters.empty?
        parameters.map { |k,v|
          requestify(v, name_with_prefix(prefix, k))
        }.join("&")
      elsif Array === parameters
        parameters.map { |v|
          requestify(v, name_with_prefix(prefix, ""))
        }.join("&")
      elsif prefix.nil?
        parameters
      else
        "#{CGI.escape(prefix)}=#{CGI.escape(parameters.to_s)}"
      end
    end
  end
end