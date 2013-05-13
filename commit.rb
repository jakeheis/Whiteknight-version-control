#!/usr/bin/env ruby 

require "./command"
require "./tree_delta"
require "./full_save"
require "fileutils"
require 'digest/sha2'
require "json"

class CommitCommand < Command

	def help_message
		"Commits"
	end

	def execute
		tree_delta = TreeDeltaCommand.delta

		currently_tracked = File.read(".wk/tracked_files").split("\n")
		new_tracked = currently_tracked - tree_delta["Removed"] + tree_delta["Added"]

		hash_string = Time.new.to_i.to_s + ENV['LOGNAME'] + tree_delta.to_s
		commit_hash = Digest::SHA2.new << hash_string

		hash = commit_hash.to_s
		commit_folder = ".wk/commits/"+hash
		FileUtils.mkdir_p commit_folder

		File.open(commit_folder+"/tree_delta", "w") {|f| f.write(JSON.dump(tree_delta))}
		FileUtils.cp(".wk/HEAD", commit_folder+"/parent")
		File.open(".wk/HEAD", "w") {|f| f.write(hash)}

		File.open(".wk/tracked_files", "w") {|f| f.write(new_tracked.join("\n"))}
		File.open(".wk/last_commit_time", "w") {|f| f.write(Time.new)}

		FullSave.save
	end

end