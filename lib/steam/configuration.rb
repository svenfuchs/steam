module Steam

  def self.config
    @@config ||= Configuration.new
  end

  def self.configure(&block)
    raise "#configure must be sent a block" unless block_given?
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
    end

  end

end
