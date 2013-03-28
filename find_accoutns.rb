#  Use this script to return the first ten URLs from a Google search.
#
#  If you have a large array, do the following:
#    If you are using RVM, switch to Ruby 1.8
#    Set @read_timeout to nil in /System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/1.8/net/protocol.rb
#    Set @read_timeout to nil in /System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/1.8/net/http.rb
#    Note: You need to be logged in as root or have sudo permissions to modify these files
#
#  Designed to run on Mac OS X. With minor modificaitons, this can work with Ubuntu as well.
#  Consult gem documentation regarding use of XPath locators versus class or id attribute locators as :xpath is not supported in all cases.

require "rubygems"
require "constants"
require "watir-webdriver"

output_file = OUTPUT_PATH + "accounts.txt" #configure your path in constants.rb and add to .gitignore

begin
  f = File.new(output_file, "w+")
  b = Watir::Browser.new
  e = Watir::Exception::UnknownObjectException
  b.goto "http://google.com"
  array = ["Diane Ablonczy","Eve Adams","Mark Adler"]
  arrayURL = ["1","2","3","4","5","6","7","8","9","10"]
  array.each do |i|
    b.text_field(:name, "q").set "#{i} canada Twitter" #add significant words here to disambiguate your search target
    b.button(:name, "btnG").click
    sleep 3
    f.puts "\n"	
    f.puts "#{i}"
	arrayURL.each do |i|
	if b.element(:xpath, "//*[@id='rso']/li[#{i}]/div/div[3]/div[1]/cite").exists? and b.element(:xpath, "//*[@id='rso']/li[#{i}]/div/div[3]/div[1]/cite").text.include? "twitter.com" #Specify the string that your URL should include to improve search precision
	f.puts b.element(:xpath, "//*[@id='rso']/li[#{i}]/div/div[3]/div[1]/cite").text
	  else next
	end
    end
end
end