module Steam
  module Connection
    autoload :Mock,   'steam/connection/mock'
    autoload :Rails,  'steam/connection/rails'
    autoload :Static, 'steam/connection/static'
  end
end