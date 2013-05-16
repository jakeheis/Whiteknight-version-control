#!/usr/bin/env ruby 

require "./command"
require "./tree_delta"
require "fileutils"
require "./apply_delta"
class LogCommand < Command

	def help_message
		"Log"
	end

	def execute
		return ApplyDeltaCommmand.apply_delta(".wk/commits/683ac4b913899676a09ee8fdc128fdb44f9b36210a1127ddb04311938e460484/deltas/commit.rb", "HEY THERE")

		if @option_hash["-c"].nil?
			count = 10000
		else
			count = @option_hash["-c"].to_i
		end

		IO.popen("less -r --chop-long-lines -X", "w") do |f|
			cur_hash = File.read(".wk/HEAD")

			count.times do |i|
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