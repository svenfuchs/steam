require 'nokogiri'

module Steam
  module Dom
    module Nokogiri
      autoload :Element, 'steam/dom/nokogiri/element'
      autoload :Page,    'steam/dom/nokogiri/page'
    end
  end
end
