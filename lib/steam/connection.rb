module Steam
  module Connection
    autoload :HtmlUnit,   'steam/connection/html_unit'
    autoload :RestClient, 'steam/connection/rest_client'
    autoload :Patron,     'steam/connection/patron'
  end
end