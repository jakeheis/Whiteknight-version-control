#!/usr/bin/env ruby 

require "darkknight/commands/command"
require "darkknight/commit"

class LogCommand < Command

	def help_message
		"Outputs a log of all commits"
	end

	def execute
		return unless Commit.has_head?

		IO.popen("less -r --chop-long-lines -X", "w") do |f|

			commit = Commit.HEAD

			while !commit.nil?
				f.puts colorize(commit.short_hash, 32)+" - "+commit.message

				commit = commit.parent_commit
			end
		end
#
	#	
	end

end