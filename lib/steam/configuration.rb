module Steam

  def self.config
    @@config ||= Configuration.new
  end

  def self.configure(&block)
    raise "#configure must be sent a block" unless block_given?
    yield config
  end

  class Configuration

    attr_accessor_with_default :java_load_params, "-Xmx2048M"
    attr_accessor_with_default :server_name, "localhost"
    attr_accessor_with_default :server_port, "3000"
    attr_accessor_with_default :rack_url_scheme, "http"
    attr_accessor_with_default :charset, "utf-8"
    attr_accessor_with_default :drb_uri, "druby://127.0.0.1:9000"
    attr_accessor_with_default :request_env_for, "http://localhost"

    def initialize
    end

  end

end
