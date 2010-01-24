module Steam

  def self.config
    @@config ||= Configuration.new
  end

  def self.configure(&block)
    raise '#configure must be sent a block' unless block_given?
    yield config
  end

  class Configuration
    attr_accessor :java_load_params
    attr_accessor :server_name
    attr_accessor :server_port
    attr_accessor :rack_url_scheme
    attr_accessor :charset
    attr_accessor :drb_uri
    attr_accessor :request_env_for

    def initialize
      # always set defaults so we don't depend on init.rb
      self.java_load_params = '-Xmx1024M'
      self.server_name      = 'localhost'
      self.server_port      = '3000'
      self.rack_url_scheme  = 'http'
      self.charset          = 'utf-8'
      self.drb_uri          = 'druby://127.0.0.1:9000'
      self.request_env_for  = 'http://localhost'
    end
  end
end
