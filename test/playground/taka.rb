require 'rubygems'
require 'open-uri'
require 'taka'

document = Taka::DOM::HTML(open('http://google.com/'))
p document.getElementsByTagName('p').map { |tag| tag.to_s }.join