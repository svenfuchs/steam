ActionController::Routing::Routes.draw do |map|
  map.namespace :test do |test|
    test.resources :sessions
  end
end
