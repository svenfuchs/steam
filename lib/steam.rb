require 'rack'

module Steam
  autoload :Browser,    'steam/browser'
  autoload :Connection, 'steam/connection'
  autoload :Java,       'steam/java'
  autoload :Process,    'steam/process'
  autoload :Request,    'steam/request'
  autoload :Response,   'steam/response'
  autoload :Session,    'steam/session'

  class ElementNotFound < StandardError
    def initialize(*args)
      super "could not find element: #{args.map { |arg| arg.inspect }.join(', ') }"
    end
  end

  class << self
    def config
      @@config ||= {
        :request_url       => 'http://localhost',
        :server_name       => 'localhost',
        :server_port       => '3000',
        :url_scheme        => 'http',
        :charset           => 'utf-8',
        :java_load_params  => '-Xmx1024M',
        :drb_uri           => 'druby://127.0.0.1:9000',
        :html_unit => {
          :java_path         => File.expand_path("../../vendor/htmlunit-2.6/", __FILE__),
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

    def save_and_open(url, response)
      filename = "/tmp/steam/#{url.gsub(/[^\w\-\/]/, '_')}.html"
      body = rewrite_assets(url, response.body)
      FileUtils.mkdir_p(File.dirname(filename))
      File.open(filename, "w") { |f| f.write body }
      open_in_browser(filename)
    end

    def open_in_browser(filename)
      require "launchy"
      Launchy::Browser.run(filename)
    rescue LoadError
      warn "Sorry, you need to install launchy to open pages: `gem install launchy`"
    end

    def rewrite_assets(url, html)
      url = url.gsub(URI.parse(url).path, '')
      pattern = %r(<script [^>]*src=['"]+([^'"]*)|<link[^>]* href=['"]?([^'"]+))
      html.gsub(pattern) { |path| path.gsub($1 || $2, "#{url}#{$1 || $2}") }
    end
  end
end