$: << File.expand_path("../../../lib", __FILE__)

require 'steam'
require 'drb'

include Steam

# # using a static connection works /w drb
# root = File.expand_path("../../fixtures/public", __FILE__)
# connection = Connection::Static.new(:root => root, :urls => ['/'])
# 
# # using a mocked connection works /w drb
# connection = Connection::Mock.new
# connection.mock 'http://localhost:3000/short.html', <<-html
# <html>
#   <head>
#     <script src="/title.js" type="text/javascript"></script>
#     <script src="/jquery-ui-1.8rc1.js" type="text/javascript"></script>
#   </head>
# </html>
# html
# connection.mock 'http://localhost:3000/title.js', "document.title = 'FOO'"
# connection.mock 'http://localhost:3000/jquery-ui-1.8rc1.js', File.read('test/fixtures/public/jquery-ui-1.8rc1.js')

# # Using the native default connection, i.e. connecting over the network, does 
# # not work /w drb when the first response has to retrieve additional assets,
# # like a js file. (There's a config.ru file in test/, so one can rackup the
# # files in test/fixtures/public.)
connection = nil

# Interestingly, this works in all situations, except that it does not implement
# a full REST interface and I don't want to implement a cookie jar and everything
# connection = Connection::OpenUri.new


# url = 'http://localhost:3000/short.html'
url = 'http://localhost:3000'

def request_without_drb(browser, url)
  browser.get(url)
  browser.response
end

def request_with_drb(browser, url)
  DRb.start_service(Steam.config[:drb_uri], browser)
  drb = DRbObject.new(nil, Steam.config[:drb_uri])
  drb.get(url)
  drb.response
end

browser = Steam::Browser.create(:html_unit, connection)
response = request_without_drb(browser, url)
# response = request_with_drb(browser, url)

puts response.body
