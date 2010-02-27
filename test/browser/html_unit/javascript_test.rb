require File.expand_path('../../../test_helper', __FILE__)
require 'fixtures/html_fakes'

class HtmlUnitJavascriptTest < Test::Unit::TestCase
  include Steam, HtmlFakes

  def setup
    @connection = Steam::Connection::Mock.new
    static = Steam::Connection::Static.new(:root => FIXTURES_PATH)
    @browser = Steam::Browser::HtmlUnit.new(Rack::Cascade.new([static, @connection]))
  end

  test "jquery: div:not([id]) selector" do
    html = <<-html
      <html>
        <head>
          <script src="/javascripts/jquery.js" type="text/javascript"></script>
          <script>
            $(document).ready(function() {
              $('div:not([id])').each(function() { 
                document.title = $(this).html();
              });
            });
          </script>
        </head>
        <body>
          <div id="foo">foo</div>
          <div>bar</div>
        </body>
      </html>
    html
    
    perform(:get, 'http://localhost:3000/', html)
    assert_equal 'bar', @browser.page.getTitleText
  end

  test "jquery: div[id*=bar] selector" do
    html = <<-html
      <html>
        <head>
          <script src="/javascripts/jquery.js" type="text/javascript"></script>
          <script>
            $(document).ready(function() {
            	$('div[id*=bar]').each(function() { 
            	  document.title = $(this).html();
            	});
            });
          </script>
        </head>
        <body>
          <div id="sidebar">foobar</div>
        </body>
      </html>
    html
    
    perform(:get, 'http://localhost:3000/', html)
    assert_equal 'foobar', @browser.page.getTitleText
  end

end