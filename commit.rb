#!/usr/bin/env ruby 

require "./command"
require "./tree_delta"
require "fileutils"

class CommitCommand < Command

	def help_message
		"Commits"
	end

	def execute
		tree_delta = TreeDeltaCommand.delta
		puts tree_delta
	end

end