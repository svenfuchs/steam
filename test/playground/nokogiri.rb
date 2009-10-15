require 'rubygems'
require 'nokogiri'

html = <<-html
<html>
  <body>
    <p class="foo bar baz">FOO</p>
  </body>
</html>
html

# p Nokogiri::CSS.xpath_for('p[content="FOO"]')
doc = Nokogiri::HTML::Document.parse(html)
p doc.css('p[class~="foo"]', 'FOO')
# p doc.xpath('//p')
