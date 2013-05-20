#!/usr/bin/env ruby 

require "darkknight/command"
require "darkknight/tree_delta"
require "fileutils"
require "darkknight/apply_delta"
class LogCommand < Command

	def help_message
		"Log"
	end

	def execute
		cur_hash = File.read(".wk/HEAD")
		return if cur_hash.length == 0

		IO.popen("less -r --chop-long-lines -X", "w") do |f|

			while true
				commit_folder = ".wk/commits/"+cur_hash+"/"

				if File.exists?(commit_folder+"message")
					message = File.read(commit_folder+"message")
				else
					message = "(No commit message)"
				end

				f.puts colorize(cur_hash[0..8], 32)+" - "+message

				cur_hash = File.read(commit_folder+"parent")

				break if cur_hash.length == 0
			end
		end
#
	#	
	end

end