#!/usr/bin/env ruby 

require "./command"
require "./tree_delta"
require "fileutils"
require "diffy"

class FullSave

	def FullSave.save
		files = []
		files << Dir[".*"].reject {|f| f == "." || f == ".." || f == ".wk" || f == ".git"}
		files << Dir["**/*"]
		files.flatten!
		FileUtils.mkdir_p(".wk/last_full")
		FileUtils.cp_r(files, ".wk/last_full")
	end

end