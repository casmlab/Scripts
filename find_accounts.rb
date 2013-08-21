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
#output_file = "/Users/libbyh/Desktop/celeb_accounts.txt"

array = ["Melinda McGraw","Archie Panjabi"]
arrayURL = ["1","2","3"]

begin
  f = File.new(output_file, "a")
  b = Watir::Browser.new
  e = Watir::Exception::UnknownObjectException
  begin
    b.goto "http://google.com"
  rescue
    sleep 3
    retry
  end

  array.each do |i|
    begin
      b.text_field(:name, "q").set "#{i} official Twitter account" #add significant words here to disambiguate your search target
      b.button(:name, "btnG").click
      sleep 3
    
      if  b.ol(:id, "rso").exists?
  	    b.ol(:id, "rso").lis.each do |li|
          if li.text.include? "https://twitter.com/"
            lines = li.text
            lines.each_line do |line|
              if line.include? "https://twitter.com" and not line.include? "status"
                account = line.gsub("https://twitter.com/","")
                f.puts "\"#{i}\"," + account              
              end # if line.include? "https://twitter.com" and not line.include? "status"
            end # loop through lines
          end #   if li.text.include? "https://twitter.com/"
        end # loop through  b.ol(:id, "rso")
      end # if  b.ol(:id, "rso") exists
    rescue
      sleep 5
      retry 
    end
  end # array.each do |i|
  b.close
  f.close
rescue
  print "something uncaptured went wrong"
end