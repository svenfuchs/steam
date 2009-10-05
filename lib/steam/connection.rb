module Steam
  module Connection
    autoload :Mock,       'steam/connection/mock'
    autoload :Patron,     'steam/connection/patron'
    autoload :Rails,      'steam/connection/rails'
    autoload :RestClient, 'steam/connection/rest_client'
    autoload :Static,     'steam/connection/static'
  end
end