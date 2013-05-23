#!/usr/bin/env ruby 

require "darkknight/commands/command"
require "darkknight/tree_delta"
require "diffy"

class DiffCommand < Command

	def help_message
		"Outputs the diff between the files in the current working tree and the files last comitted"
	end

	def execute
		tree_delta = TreeDelta.delta

		tree_delta["Modified"].each do |f|
			puts colorize(f, 33)
			puts colorize("Editted at #{File.mtime(f)}", 33)

			old_path = ".wk/compare_full/#{f}"
			puts Diffy::Diff.new(old_path, f, :source => "files", :context => 5, :allow_empty_diff => true).to_s(:color)
		end
	end

end