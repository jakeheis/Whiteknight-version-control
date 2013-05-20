#!/usr/bin/env ruby 

require "darkknight/command"
require "darkknight/tree_delta"
require "fileutils"
require "diffy"

class DiffCommand < Command

	def help_message
		"Diff"
	end

	def execute
		tree_delta = TreeDeltaCommand.delta

		tree_delta["Modified"].each do |f|
			puts colorize(f, 33)
			puts colorize("Editted at #{File.mtime(f)}", 33)

			old_path = ".wk/last_full/#{f}"
			puts Diffy::Diff.new(old_path, f, :source => "files", :context => 5, :allow_empty_diff => true).to_s(:color)
		end
	end

	def DiffCommand.diff

	end

end
# Couple additions
# Couple additions 2