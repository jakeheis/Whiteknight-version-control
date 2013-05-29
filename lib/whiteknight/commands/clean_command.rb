#!/usr/bin/env ruby 

require "whiteknight/commands/command"
require "fileutils"

class CleanCommand < Command

	def help_message
		"Specify: --all, --commits"
	end

	def execute
		if @args.length < 1
			help
		elsif @option_hash.has_key?("--all")
			FileUtils.rm_rf(".wk")
		elsif @option_hash.has_key?("--commits")
			FileUtils.rm_rf(".wk/commits")
			FileUtils.mkdir_p(".wk/commits")
		else
			help
		end
	end

end