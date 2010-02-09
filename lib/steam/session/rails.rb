module Steam
  class Session
    class Rails < Session
      include ActionController

      def initialize(browser = nil)
        super

        # install the named routes in this session instance.
        klass = class << self; self; end
        ActionController::Routing::Routes.install_helpers(klass)
        klass.module_eval { public *Routing::Routes.named_routes.helpers }
      end

      # FIXME we only have access to the controller when Steam can run HtmlUnit
      # and the app in one stack
      def controller
      end
      
      def url_for(options) 
        controller ? controller.url_for(options) : generic_url_rewriter.rewrite(options)
      end
      
      protected

        # FIXME remove ActionController::Request dependency
        def generic_url_rewriter 
          env = Request.env_for(Steam.config[:request_url])
          UrlRewriter.new(ActionController::Request.new(env), {})
        end
    end
  end
end