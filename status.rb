#!/usr/bin/env ruby 

require "./command"
require "./tree_delta"
require "fileutils"

class StatusCommand < Command

	def help_message
		"Status"
	end

	def execute
		tree_delta = TreeDeltaCommand.delta
		tree_delta["Added"].each do |f|
			puts "A #{f}"
		end
		tree_delta["Modified"].each do |f|
			puts "M #{f}"
		end
		tree_delta["Removed"].each do |f|
			puts "R #{f}"
		end
	end

end