#!/usr/bin/env ruby 

require "./command"
require "time"

class TreeDeltaCommand
	def TreeDeltaCommand.delta
		last_udpated = nil
		already_tracked_files = []
		if File.exists?(".wk/last_commit_time") then File.open(".wk/last_commit_time", "r") {|f| last_udpated = Time.parse(f.gets)}
		else last_udpated = Time.at(0)
		end

		already_tracked_files = File.read(".wk/tracked_files").split("\n")

		files = []
		files << Dir[".*"].reject {|f| f == "." || f == ".." || f == ".wk"}
		files << Dir["**/*"]
		files.flatten!
#

		tracked_files = []
		new_files = []
		editted_files = []
		files.each do |f|
			if !already_tracked_files.include? f
				new_files << f
			elsif File.mtime(f) > last_udpated
				editted_files << f
			end
			already_tracked_files.delete(f)
			tracked_files << f
		end

		deleted_files = already_tracked_files

		File.open(".wk/last_delta", "w") {|f| f.write(Time.new)}
		# File.open(".wk/tracked_files", "w") {|f| f.write(tracked_files.join("\n"))}

		return {"Added" => new_files, "Modified" => editted_files, "Removed" => deleted_files}
	end

end