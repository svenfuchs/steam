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

      # FIXME! how to get access to the controller?
      def controller
      end
      
      def url_for(options) 
        controller ?
          controller.url_for(options) :
          generic_url_rewriter.rewrite(options)
      end
      
      protected

        # FIXME remove ActionController::Request dependency
        def generic_url_rewriter 
          env = Request.env_for('http://localhost')
          UrlRewriter.new(ActionController::Request.new(env), {})
        end
    end
  end
end