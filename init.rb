#!/usr/bin/env ruby 

require "./command"
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
		File.open(".wk/tags", "w") {|f| f.write("")}
		File.open(".wk/remotes", "w") {|f| f.write("")}
		File.open(".wk/HEAD", "w") {|f| f.write("")}
	end

end