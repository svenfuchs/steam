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
