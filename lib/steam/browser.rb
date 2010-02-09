# We currently only implement HtmlUnit as a browser. Maybe at some point
# Webdriver might be an interesting alternative.
module Steam
  module Browser
    autoload :HtmlUnit, 'steam/browser/html_unit'
  end
end