# ActionController::Dispatcher.class_eval do
#   def call(env)
#     @app ||= build_middleware_stack
#     @app.call(env)
#   end
# end
#
# ActionController::Dispatcher.middleware.instance_eval do
#   use Steam::Reloader
# end

Steam.configure do |config|
  # jvm load params - lib/steam/java.rb
  #:javaloadparams: "'-Xms256M', '-Xmx2048M'"
  config.java_load_params = "-Xmx1024M"

  # common params - lib/steam/request.rb
  config.server_name = "localhost"
  config.server_port = "3000"
  config.rack_url_scheme = "http"

  # char params - lib/steam/browser/html_unit/connection.rb + web_response.rb
  config.charset = "utf-8"

  # drb params - lib/steam/browser/html_unit/drb/service.rb
  config.drb_uri = "druby://127.0.0.1:9000"

  # JS params - lib/steam/browser/html_unit/html_unit.rb
  #@client.waitForBackgroundJavaScript(5000) # FIXME should probably use some block syntax

  # env params - lib/steam/connection/patron.rb
  #headers = {}              # FIXME ... request.header, cookies?
  #options = { :data => '' } # FIXME ... body

  # env params - lib/steam/session/rails.rb
  config.request_env_for = "http://localhost"
end
