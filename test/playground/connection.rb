$: << File.expand_path(File.dirname(__FILE__) + "/../../lib")
require 'steam'
include Steam

Java.import 'com.gargoylesoftware.htmlunit.WebClient'
Java.import 'com.gargoylesoftware.htmlunit.BrowserVersion'

client = Java::WebClient.new(Java::BrowserVersion.FIREFOX_3)
client.setCssEnabled(true)
client.setJavaScriptEnabled(true)

mock = Connection::Mock.new
mock.mock :get, 'http://localhost:3000/', 'body!'

connection = Browser::HtmlUnit::Connection.new(mock)
client.setWebConnection(Rjb::bind(connection, 'com.gargoylesoftware.htmlunit.WebConnection'))

page = client.getPage('http://localhost:3000/')
puts page.asXml