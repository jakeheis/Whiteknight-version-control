#!/usr/bin/env ruby 

require "darkknight/commands/command"
require "fileutils"

class InitCommand < Command

	def help_message
		"Intializes an empty wk repository in the current directory. No arguments should be given."
	end

	def execute
		FileUtils.mkdir_p ".wk"

		FileUtils.mkdir_p ".wk/commits"

		File.open(".wk/last_commit_time", "w") {|f| f.write(Time.new)}
		File.open(".wk/tracked_files", "w") {|f| f.write("")}
	end

end