require 'rack'

module Steam
  autoload :Browser,    'steam/browser'
  autoload :Connection, 'steam/connection'
  autoload :Java,       'steam/java'
  autoload :Reloader,   'steam/reloader'
  autoload :Request,    'steam/request'
  autoload :Response,   'steam/response'
  autoload :Session,    'steam/session'

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
          :java_path         =>  File.expand_path("../htmlunit-2.6/", __FILE__),
          :browser_version   => :FIREFOX_3,
          :css               => true,
          :javascript        => true,
          :resynchronize     => true,
          :js_timeout        => 5000,
          :log_level         => :warning,
          :log_incorrectness => false,
          :on_error_status   => nil, # set to :raise to raise an exception on error status, :print to print content
          :on_script_error   => nil  # set to :raise to raise an exception on javascript exceptions
        }
      }
    end
  end

  class ElementNotFound < StandardError
    def initialize(*args)
      super "could not find element: #{args.map { |arg| arg.inspect }.join(', ') }"
    end
  end
end