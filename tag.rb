#!/usr/bin/env ruby 

require "./command"
require "fileutils"

class TagCommand < Command

	def help_message
		"Tags the commit with the hash given in the first argument with the tag given in the second argument. Requires two arguments."
	end

	def execute
		return help if @args.count != 2
		glob = Dir.glob(".wk/commits/"+@args[0]+"*")
		return help if glob.empty?

		first_path = glob[0]
		first_hash = first_path.split(File::SEPARATOR)[2]

		File.open(".wk/tags", "a") {|f| f.puts(@args[1]+" -> "+first_hash)}		
	end

end