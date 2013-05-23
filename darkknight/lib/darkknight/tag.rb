#!/usr/bin/env ruby 

require "darkknight/commit"

class Tag

	def Tag.tag(commit_hash, tag)
		if File.exists?(".wk/tags") then tags = JSON.parse(File.read(".wk/tags"))
		else tags = {} end

		tags[tag] = commit_hash

		File.open(".wk/tags", "w") {|f| f.write(JSON.dump(tags))}
	end

	def Tag.commit_hash_for_tag(tag)
		if File.exists?(".wk/tags") then tags = JSON.parse(File.read(".wk/tags"))
		else tags = {} end

		hash = tags[tag]

		return hash
	end

	# def FullSave.save(path)
	# 	files = []
	# 	files << Dir[".*"].reject {|f| f == "." || f == ".." || f == ".wk" || f == ".git"}
	# 	files << Dir["**/*"].reject {|f| File.directory?(f)}
	# 	files.flatten!
	# 	puts "FILES #{files}"
	# 	FileUtils.mkdir_p(path)
	# 	FileUtils.cp_r(files, path)
	# end

end