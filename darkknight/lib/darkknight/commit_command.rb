#!/usr/bin/env ruby 

require "darkknight/command"
require "darkknight/tree_delta"
require "darkknight/full_save"
require "darkknight/commit"
require "fileutils"
require 'digest/sha2'
require "json"

class CommitCommand < Command

	def help_message
		"Commits"
	end

	def create_commit_folder
		hash_string = Time.new.to_i.to_s + ENV['LOGNAME'] + @tree_delta.to_s
		commit_hash = Digest::SHA2.new << hash_string
		@hash = commit_hash.to_s
		@commit_folder = ".wk/commits/"+@hash
		FileUtils.mkdir_p @commit_folder
	end

	def save_new
		FileUtils.mkdir @commit_folder+"/added"
		@tree_delta["Added"].each do |f|
			FileUtils.mkdir_p("#{@commit_folder}/added/#{File.dirname(f)}")
			FileUtils.cp(f, "#{@commit_folder}/added/#{f}")
		end
	end

	def save_file_deltas
		FileUtils.mkdir @commit_folder+"/deltas"
		@tree_delta["Modified"].each do |f|			
			old_path = ".wk/last_full/#{f}"
			delta = Diffy::Diff.new(old_path, f, :source => "files", :context => 0, :allow_empty_diff => true, :include_diff_info => true).to_s(:text)
			File.open("#{@commit_folder}/deltas/#{f}", "w") {|f| f.write(delta)}
		end
	end

	def save_message
		File.open(@commit_folder+"/message", "w") {|f| f.write(@option_hash["-m"])} unless @option_hash["-m"].nil?
	end

	def save_tree_delta
		File.open(@commit_folder+"/tree_delta", "w") {|f| f.write(JSON.dump(@tree_delta))}
	end

	def update_head


		unless File.exists?(".wk/HEAD")
			File.open(".wk/HEAD", "w") {|f| f.write(@hash)}
			return
		end

		old_head = File.open(".wk/HEAD").read
		File.open(".wk/commits/#{old_head}/child", "w") {|f| f.write(@hash)} 
		File.open("#{@commit_folder}/parent", "w") {|f| f.write(old_head)}

		File.open(".wk/HEAD", "w") {|f| f.write(@hash)}
	end

	def update_tracked
		currently_tracked = File.read(".wk/tracked_files").split("\n")
		new_tracked = currently_tracked - @tree_delta["Removed"] + @tree_delta["Added"]
		File.open(".wk/tracked_files", "w") {|f| f.write(new_tracked.join("\n"))}
	end

	def update_commit_num

	end

	def execute
		# @tree_delta = TreeDeltaCommand.delta

		# create_commit_folder

		# save_new
		# save_file_deltas
		# save_message
		# save_tree_delta

		# update_head
		# update_tracked


		commit = Commit.commit(@option_hash)


		File.open(".wk/last_commit_time", "w") {|f| f.write(Time.new)}

		# Save the full tree first
		FullSave.save(".wk/last_full")

		puts "Created commit #{commit.hash[0..8]}"
	end

end