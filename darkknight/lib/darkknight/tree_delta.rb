#!/usr/bin/env ruby 

require "darkknight/command"
require "time"
require "diffy"

class TreeDelta

	def TreeDelta.delta
		last_updated = nil
		already_tracked_files = []
		if File.exists?(".wk/last_commit_time") then File.open(".wk/last_commit_time", "r") {|f| last_updated = Time.parse(f.gets)}
		else last_updated = Time.at(0)
		end

		already_tracked_files = File.read(".wk/tracked_files").split("\n")

		files = []
		files << Dir[".*"].reject {|f| f == "." || f == ".." || f == ".wk" || f == ".git"}
		files << Dir["**/*"].reject {|f| File.directory?(f)}
		files.flatten!

		tracked_files = []
		new_files = []
		editted_files = []

		files.each do |f|
			if !already_tracked_files.include? f
				new_files << f
			elsif File.mtime(f) > last_updated
				editted_files << f
			end
			already_tracked_files.delete(f)
			tracked_files << f
		end

		editted_files.reject! {|f| File.read(".wk/compare_full/#{f}") == File.read(f)}

		deleted_files = already_tracked_files

		return {"Added" => new_files, "Modified" => editted_files, "Removed" => deleted_files}
	end

	def TreeDelta.dirty_tree?
		delta = TreeDelta.delta
		delta["Added"].count !=0 || delta["Modified"].count != 0 || delta["Removed"].count != 0
	end

end