#!/usr/bin/env ruby 

require "./command"
require "./tree_delta"
require "fileutils"
require "diffy"

class DiffCommand < Command

	def help_message
		"Diff"
	end

	def execute
		tree_delta = TreeDeltaCommand.delta

		Diffy::Diff.default_format = :color

		tree_delta["Modified"].each do |f|
			puts colorize(f, 33)

			puts colorize("Editted at #{File.mtime(f)}", 33)

			old_path = ".wk/last_full/#{f}"
			old_contents = File.open(old_path, "rb").read
			cur_contents = File.open(f, "rb").read
			puts Diffy::Diff.new(old_contents, cur_contents)
		end
	end

end