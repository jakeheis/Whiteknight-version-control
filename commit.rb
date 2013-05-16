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

	def modified
		@tree_delta["Modified"].each do |f|			
			old_path = ".wk/last_full/#{f}"
			delta = Diffy::Diff.new(old_path, f, :source => "files", :context => 0, :allow_empty_diff => true, :include_diff_info => true).to_s(:text)
			File.open("#{@commit_folder}/deltas/#{f}", "w") {|f| f.write(delta)}
		end
	end

	def execute
		# Tree delta
		@tree_delta = TreeDeltaCommand.delta

		currently_tracked = File.read(".wk/tracked_files").split("\n")
		new_tracked = currently_tracked - @tree_delta["Removed"] + @tree_delta["Added"]

		# Setup commit folder
		hash_string = Time.new.to_i.to_s + ENV['LOGNAME'] + @tree_delta.to_s
		commit_hash = Digest::SHA2.new << hash_string

		hash = commit_hash.to_s
		@commit_folder = ".wk/commits/"+hash
		FileUtils.mkdir_p @commit_folder

		# Store stuff in commit folder
		File.open(@commit_folder+"/tree_delta", "w") {|f| f.write(JSON.dump(@tree_delta))}
		FileUtils.mkdir @commit_folder+"/deltas"
		modified

		FullSave.save(@commit_folder+"/full")

		File.open(@commit_folder+"/message", "w") {|f| f.write(@option_hash["-m"])} unless @option_hash["-m"].nil?
		
		# Update HEAD
		FileUtils.cp(".wk/HEAD", @commit_folder+"/parent")
		File.open(".wk/HEAD", "w") {|f| f.write(hash)}

		# Update other files
		File.open(".wk/tracked_files", "w") {|f| f.write(new_tracked.join("\n"))}
		File.open(".wk/last_commit_time", "w") {|f| f.write(Time.new)}

		# Save the full tree for later comparison
		FullSave.save(".wk/last_full")

		puts "Created commit #{hash}"
	end

end