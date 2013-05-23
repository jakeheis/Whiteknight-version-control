#!/usr/bin/env ruby 

require "darkknight/command"
require "darkknight/tree_delta"
require "darkknight/full_save"
require "darkknight/commit"
require "fileutils"
require 'digest/sha2'
require "json"

class CommitCommand < Command

	def help_message
		"Commits the current working tree"
	end

	def execute
		commit = Commit.commit(@option_hash)

		File.open(".wk/last_commit_time", "w") {|f| f.write(Time.new)}
		FullSave.save(".wk/compare_full")

		puts "Created commit #{commit.short_hash}"
	end

end