class MockConnection
  def initialize
    @connection = Java::MockWebConnection.new
  end
end

module Steam
  module Browser
    class HtmlUnit
      class MockConnection
        attr_reader :connection
        
        class << self
          def public_dir
            @@public_dir ||= RAILS_ROOT + '/'
          end
          
          def public_dir=(public_dir)
            @@public_dir = public_dir
          end
        end
        
        def initialize
          @connection = HtmlUnit::Java::MockWebConnection.new
        end

        def method_missing(method, *args)
          p [method, args.first.toString]
          connection.send(method, *args)
        end

        def mock_response(uri, response)
          connection.setResponse(Java::Url.new(uri.to_s), response.body)
          mock_static_files(response, :javascript, 'application/javascript')
          mock_static_files(response, :stylesheet, 'text/css')
        end

        protected

          def mock_static_files(response, type, content_type)
            response.send(:"#{type}_urls").each do |url|
              body = read_static_file(url)
              url  = Java::Url.new("http://localhost:3000#{url}")
              connection.setResponse(url, body, content_type)
            end
          end

          def read_static_file(url)
            filename = "#{self.class.public_dir}#{url.gsub(/\?\d*/, '')}"
            File.open(filename) { |file| file.read }
          end
      end
    end
  end
end