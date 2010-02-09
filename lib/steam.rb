require 'rack'

module Steam
  autoload :Browser,         'steam/browser'
  autoload :Connection,      'steam/connection'
  autoload :ElementNotFound, 'steam/exceptions'
  autoload :Java,            'steam/java'
  autoload :Reloader,        'steam/reloader'
  autoload :Request,         'steam/request'
  autoload :Session,         'steam/session'
  
  class << self
    def config
      @@config ||= {
        :request_env_for  => 'http://localhost',
        :server_name      => 'localhost',
        :server_port      => '3000',
        :rack_url_scheme  => 'http',
        :charset          => 'utf-8',
        :java_load_params => '-Xmx1024M'
      }
    end
  end
  
  # Steam.configure do |config|
  #   # jvm load params - lib/steam/java.rb
  #   # :javaloadparams: "'-Xms256M', '-Xmx2048M'"
  #   config.java_load_params = "-Xmx1024M"
  # 
  #   # common params - lib/steam/request.rb
  #   config.server_name = "localhost"
  #   config.server_port = "3000"
  #   config.rack_url_scheme = "http"
  # 
  #   # char params - lib/steam/browser/html_unit/connection.rb + web_response.rb
  #   config.charset = "utf-8"
  # 
  #   # drb params - lib/steam/browser/html_unit/drb/service.rb
  #   config.drb_uri = "druby://127.0.0.1:9000"
  # 
  #   # JS params - lib/steam/browser/html_unit/html_unit.rb
  #   # @client.waitForBackgroundJavaScript(5000) # FIXME should probably use some block syntax
  # 
  #   # env params - lib/steam/session/rails.rb
  #   config.request_env_for = "http://localhost"
  # end
end