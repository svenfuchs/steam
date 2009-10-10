# require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

$: << File.expand_path(File.dirname(__FILE__) + "/../../lib")
require 'steam'
include Steam

page = <<-erb
  <html>
    <head>
      <!-- <script>
        document.title = 'ajaxing ...'
        http = new XMLHttpRequest();
        http.open("GET", "/ajax", true);
        http.onreadystatechange = function() {
          if(http.readyState == 4) document.title = http.responseText
        }
        http.send(null);    
      </script> -->
    </head>
  </html>
erb
mock = Connection::Mock.new
# mock.mock :get, 'http://localhost:3000/', page
# mock.mock :get, 'http://localhost:3000/ajax', 'ajaxed!'

root = File.expand_path(File.dirname(__FILE__) + '/../fixtures/rails/public')
static = Connection::Static.new(:root => root)

# rails_root = File.expand_path(File.dirname(__FILE__) + '/../fixtures/rails')
# require rails_root + '/config/environment.rb'

# url = 'http://localhost:3000/users'
# rails = Connection::Rails.new
# connection = Rack::Cascade.new([static, mock])
browser = Browser::HtmlUnit.new(mock)

status, headers, response = browser.call(Request.env_for('http://localhost:3000/'))
p status
puts response.body
p browser.page.getTitleText
