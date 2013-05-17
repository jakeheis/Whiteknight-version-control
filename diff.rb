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

		str = Diffy::Diff.new("tester_s", "tester_f", :source => "files", :context => 0, :allow_empty_diff => true, :include_diff_info => true).to_s(:text)
		File.open("tester_d", "w") {|e| e.write(str)}
		applied = ApplyDeltaCommmand.apply_delta("tester_d", "tester_s")
		File.open("tester_result", "w") {|e| e.write(applied)}

		tree_delta["Modified"].each do |f|
			puts colorize(f, 33)
			puts colorize("Editted at #{File.mtime(f)}", 33)

			old_path = ".wk/last_full/#{f}"
			# puts Diffy::Diff.new(old_path, f, :source => "files", :context => 5, :allow_empty_diff => true).to_s(:color)
		end
	end

	def DiffCommand.diff

	end

end