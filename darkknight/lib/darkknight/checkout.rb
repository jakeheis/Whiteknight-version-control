#!/usr/bin/env ruby 

require "fileutils"
require "darkknight/command"
require "darkknight/tree_delta"
require "darkknight/apply_delta"

class CheckoutCommand < Command

	def help_message
		"Checkout the given commit"
	end

	def execute
		return help if @args.count != 1
		glob = Dir.glob(".wk/commits/"+@args[0]+"*")
		return help if glob.empty?
		commit = glob[0]

		# parent = File.open("#{commit}/parent").read
		full = "#{commit}/full"
		files = []
		Dir.chdir(full) do
			files = Dir["**/*"].reject {|f| File.directory?(f)}
		end

		files.each do |f|
			FileUtils.cp("#{full}/#{f}", f)
		end

	end

end