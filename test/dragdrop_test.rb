$: << File.expand_path("../../lib", __FILE__)

require 'steam'

include Steam

@app = Connection::Mock.new
root = File.expand_path("../fixtures/public", __FILE__)
static = Connection::Static.new(:root => root, :urls => %w(/ /javascripts /stylesheets))
@browser = Browser::HtmlUnit.new(Rack::Cascade.new([static, @app]))

def drag_to(target)
  @browser.page.executeJavaScript('$("#log").text("")')

  drag = @browser.locate_in_browser(:div, :class => 'drag')
  drop = @browser.locate_in_browser(:div, :id => target)

  puts "\nDROPPING ONTO (#{drop.getCanonicalXPath}):\n" + drop.asXml

  drag.mouseDown
  drop.mouseMove
  page = drop.mouseUp

  log = page.executeJavaScript('$("#log").text()').getJavaScriptResult
  puts "RECEIVED DROP EVENT ON:\n" + log.toString
end

@browser.request('/index.html')
drag_to('drop_1')
drag_to('drop_2')
drag_to('drop_3')
drag_to('drop_4')
drag_to('drop_5')
drag_to('drop_6')

# OUTPUT:
#
# DROPPING ONTO (/html/body/div[2]):
# <div class="drop ui-droppable" id="drop_2">
# </div>
# RECEIVED DROP EVENT ON:
# <div id="drop_1" class="drop ui-droppable"></div>
#
# DROPPING ONTO (/html/body/div[3]):
# <div class="drop ui-droppable" id="drop_3">
# </div>
# RECEIVED DROP EVENT ON:
# <div id="drop_2" class="drop ui-droppable"></div>
#
# DROPPING ONTO (/html/body/div[4]):
# <div class="drop ui-droppable" id="drop_4">
# </div>
# RECEIVED DROP EVENT ON:
# <div id="drop_3" class="drop ui-droppable"></div>



