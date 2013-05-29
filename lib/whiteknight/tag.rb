#!/usr/bin/env ruby 

require "json"

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

end