require 'rubygems'
require 'webrat'


class Browser
  include Webrat::Locators
  
  class Cache
    def elements
      @elements ||= {}
    end
    
    def clear
      @elements.clear
    end
  end
  
  def initialize
    @cache = Cache.new
  end
  
  def find_link(text_or_title_or_id)
    element = LinkLocator.new(@cache, dom, text_or_title_or_id).locate!
  end
  
  def dom
    Webrat::XML.xml_document(html)
  end
  
  def html
    <<-html
      <html>
        <head>
        </head>
        <body>
          <a href="/">Home</a>
          <p>Welcome!</p>
          <p>Click here to <a href="/foo">foo</a>.</p>
        </body>
      </html>
    html
  end
end

browser = Browser.new
# p Webrat::XML.xpath_to(browser.find_link_element('foo'))
p browser.find_link('foo').path

