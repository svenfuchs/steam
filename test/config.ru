use Rack::Lock
use Rack::Static, :root => File.expand_path("../fixtures/public", __FILE__), :urls => ['/']
run lambda { |*nothing| }
