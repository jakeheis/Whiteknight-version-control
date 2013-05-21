#!/usr/bin/env ruby 

require "darkknight/command"
require "darkknight/tree_delta"
require "fileutils"
require "diffy"

class FullSave

	def FullSave.save(path)
		files = []
		files << Dir[".*"].reject {|f| f == "." || f == ".." || f == ".wk" || f == ".git"}
		files << Dir["**/*"].reject {|f| File.directory?(f)}
		files.flatten!
		puts "FILES #{files}"
		FileUtils.mkdir_p(path)
		FileUtils.cp_r(files, path)
	end

end