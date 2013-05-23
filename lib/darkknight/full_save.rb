#!/usr/bin/env ruby 

require "fileutils"

class FullSave

	def FullSave.save(path)
		files = []
		files << Dir[".*"].reject {|f| f == "." || f == ".." || f == ".wk" || f == ".git"}
		files << Dir["**/*"].reject {|f| File.directory?(f)}
		files.flatten!
		FileUtils.mkdir_p(path)
		files.each do |f|
			FileUtils.mkdir_p("#{path}/#{File.dirname(f)}")
			FileUtils.cp(f, "#{path}/#{f}")
		end
	end

end