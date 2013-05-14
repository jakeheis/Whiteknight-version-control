#!/usr/bin/env ruby 

require "./command"
require "./tree_delta"
require "fileutils"
require "diffy"

class FullSave

	def FullSave.save(path)
		files = []
		files << Dir[".*"].reject {|f| f == "." || f == ".." || f == ".wk" || f == ".git"}
		files << Dir["**/*"]
		files.flatten!
		FileUtils.mkdir_p(path)
		FileUtils.cp_r(files, path)
	end

end