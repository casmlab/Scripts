# !/usr/bin/ruby -w
# get_tweets_by_user.rb - creates a text file for each person requested where each
# line in the text file is a single tweet
#
# ARGS:
# user_type as an integer
# output_pats as full file path with trailing /

require "rubygems"
require "mysql"
require "constants" # connection params like host, password
require "shared" # shared functions, usually about MySQL

# quit unless our script gets two command line arguments
unless ARGV.length == 2
  puts "This script expects a user type (as int) and output file path (with trailing /)."
  puts "Usage: ruby get_tweets_by_user.rb user_type output_path\n"
  exit
end

USER_TYPE = ARGV[0]
OUTPUT_PATH = ARGV[1]	

#
# Write the text file
#
def write_text_file(user_id, screen_name)
  output = OUTPUT_PATH + screen_name + ".txt"
  
  counter = 0
  puts "Writing #{screen_name}"
  
  f = File.new(output,"w+")
  result = @db.prepare("
    SELECT tweet_text FROM tweets WHERE user_id = #{user_id}
    ").execute.to_h
  
  result.each do |row|
    counter+=1
    f.puts row['tweet_text'].gsub(/\r/," ").gsub(/\n/," ")
  end
  
  puts "wrote #{counter} tweets to file"
end

#
# Class Getter
# Handles all steps for getting data
# 
class Getter
	# Handle for the database connection
	@db		

	#
	# Open the database connection
	#
	def open
		@db = open_remote
	end

	#
	# Close the database connection
	#
	def close
		@db.close if @db
		@db = nil
	end
	
	# 
	# Get IDs for users we want to grab
	#
	def get_tweets
	  result = @db.prepare("
	    SELECT user_id, screen_name FROM users_long WHERE type = #{USER_TYPE}
	    ").execute.to_h
	    
	  result.each do |row|
	    write_text_file row['user_id'], row['screen_name']
	  end
	end
	
	#
	# Perform all grabber operations
	#
	def run
		open
    get_tweets
		close
	end
end

# do all the stuff
getter = Getter.new.run