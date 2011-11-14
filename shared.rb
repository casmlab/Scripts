# shared.rb
# common/shared functions used in multiple scripts/apps

def open_remote

  Mysql.new(
	  HOST,
	  USER,
	  PASSWORD,
	  DATABASE  
	)
end

#
# Local classes
#

class Mysql::Stmt

	#
	# Make an array of arrays out of the incoming result rows.
	#
	# This is necessary, because the rows in the resultset can
	# not be read when the db or statement instance is closed.
	# And we need to transfer the data from one db connection
	# to another.
	#
	def to_a
		arr = ResultArray.new 
		self.each do |row|
			arr << row
		end

		arr
	end


	#
	# Make an array of hashes out of the incoming result rows.
	#
	# This is used to pass row values as properties into the
	# template system.
	#
	def to_h
		md = self.result_metadata()
		arr = [] 
		self.each do |row|
			hash  = {}
			md.fetch_fields.each_with_index do |info, i|
				hash[info.name] = row[i]
			end
			arr << hash
		end

		arr
	end
end