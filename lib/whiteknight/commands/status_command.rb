#!/usr/bin/env ruby 

require "whiteknight/commands/command"
require "whiteknight/tree_delta"

class StatusCommand < Command

	def help_message
		"Displays the status of the current working tree"
	end

	def execute
		tree_delta = TreeDelta.delta
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