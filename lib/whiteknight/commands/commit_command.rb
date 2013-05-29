#!/usr/bin/env ruby 

require "whiteknight/commands/command"
require "whiteknight/full_save"
require "whiteknight/commit"

class CommitCommand < Command

	def help_message
		"Commits the current working tree. Can specify an optional message with -m"
	end

	def execute
		commit = Commit.commit(@option_hash)

		File.open(".wk/last_commit_time", "w") {|f| f.write(Time.new)}
		FullSave.save(".wk/compare_full")

		puts "Created commit #{commit.short_hash}"
	end

end