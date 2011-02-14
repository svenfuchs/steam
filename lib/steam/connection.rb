module Steam
  module Connection
    autoload :Mock,    'steam/connection/mock'
    autoload :NetHttp, 'steam/connection/net_http'
    autoload :OpenUri, 'steam/connection/open_uri'
    autoload :Rails,   'steam/connection/rails'
    autoload :Static,  'steam/connection/static'
  end
end