require 'rack'

module Steam
  autoload :Browser,         'steam/browser'
  autoload :Connection,      'steam/connection'
  autoload :ElementNotFound, 'steam/exceptions'
  autoload :Java,            'steam/java'
  autoload :Reloader,        'steam/reloader'
  autoload :Request,         'steam/request'
  autoload :Response,        'steam/response'
  autoload :Session,         'steam/session'

  class << self
    def config
      @@config ||= {
        :request_url       => 'http://localhost',
        :server_name       => 'localhost',
        :server_port       => '3000',
        :url_scheme        => 'http',
        :charset           => 'utf-8',
        :java_load_params  => '-Xmx1024M',
        :html_unit => {
          :css             => true,
          :javascript      => true,
          :js_timeout      => 5000,
          :on_error_status => nil   # set to :print to print content on error status, :fail to raise an exception
        }
      }
    end
  end
end