#!/usr/bin/env ruby 

require "fileutils"
require "darkknight/command"
require "darkknight/tree_delta"
require "darkknight/apply_delta"

class CheckoutCommand < Command

	def help_message
		"Checkout the given commit"
	end

	def execute
		return help if @args.count != 1
		if @args[0] == "HEAD"
			checked_out_commit = Commit.HEAD
		else
			glob = Dir.glob(".wk/commits/"+@args[0]+"*")
			return help if glob.empty?

			commit_hash = glob[0]

			parts = commit_hash.split("/")
			checked_out_commit = Commit.new(parts[2])
		end
		
		return puts "The working tree must not be dirty." if TreeDelta.dirty_tree?

		full_commit = checked_out_commit.last_full_commit

		full_dir = "#{full_commit.folder}/full"
		files = []
		Dir.chdir(full_dir) do
			files = Dir["**/*"].reject {|f| File.directory?(f)}
		end

		wipe_directory
		files.each do |f|
			FileUtils.cp("#{full_dir}/#{f}", f)
		end

		return if full_commit == checked_out_commit

		commit_step = full_commit.child_commit
		while commit_step.hash != checked_out_commit.hash
			puts "Commit step #{commit_step.hash} trying #{checked_out_commit.hash}"
			apply_commit(commit_step)
			commit_step = commit_step.child_commit
		end

		apply_commit(checked_out_commit)

	end

	def wipe_directory
		files = []
		files << Dir[".*"].reject {|f| f == "." || f == ".." || f == ".wk" || f == ".git"}
		files << Dir["**/*"].reject {|f| File.directory?(f)}
		files.flatten!
		files.each {|f| File.delete(f)}
	end

	def apply_commit(commit)
		commit.tree_delta["Removed"].each do |f|
			File.delete(f)
		end
		commit.tree_delta["Added"].each do |f|
			FileUtils.mkdir_p("#{File.dirname(f)}")
			FileUtils.cp "#{commit.folder}/added/#{f}", f
		end
		commit.tree_delta["Modified"].each do |f|
			ApplyDelta.apply_delta("#{commit.folder}/deltas/#{f}", f)
		end
	end

end