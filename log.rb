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
		# existing = File.open(".wk/last_full/apply_delta.rb").read
		existing = File.open("start").read
		return ApplyDeltaCommmand.apply_delta(".wk/commits/308ab1f4f0f87673a8cdd649069aeba275f4f9b6fbb984f20ca07f134ea71968/deltas/apply_delta.rb", existing)

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