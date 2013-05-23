#!/usr/bin/env ruby 

require "fileutils"
require "darkknight/command"
require "darkknight/tree_delta"
require "darkknight/apply_delta"
require "darkknight/tag"

class BuildTree

	def initialize(dir, commit)
		@build_directory = dir
		@commit = commit
	end

	def build
		full_commit = @commit.last_full_commit

		full_dir = "#{full_commit.folder}/full"
		files = []
		Dir.chdir(full_dir) do
			files = Dir["**/*"].reject {|f| File.directory?(f)}
		end

		FileUtils.mkdir_p(@build_directory)
		wipe_directory

		files.each do |f|
			FileUtils.mkdir_p(@build_directory+File.dirname(f))
			FileUtils.cp("#{full_dir}/#{f}", @build_directory+f)
		end

		return if full_commit == @commit

		commit_step = full_commit.child_commit
		while commit_step.hash != @commit.hash
			apply_commit(commit_step)
			commit_step = commit_step.child_commit
		end

		apply_commit(@commit)
	end

	def wipe_directory
		Dir.chdir(@build_directory) do
			files = []
			files << Dir[".*"].reject {|f| f == "." || f == ".." || f == ".wk" || f == ".git"}
			files << Dir["**/*"].reject {|f| File.directory?(f)}
			files.flatten!
			files.each {|f| File.delete(f)}
		end
	end

	def apply_commit(commit)
		commit.tree_delta["Removed"].each do |f|
			File.delete(@build_directory+f)
		end
		commit.tree_delta["Added"].each do |f|
			FileUtils.mkdir_p(@build_directory+File.dirname(f))
			FileUtils.cp("#{commit.folder}/added/#{f}", @build_directory+f)
		end
		commit.tree_delta["Modified"].each do |f|
			ApplyDelta.apply_delta("#{commit.folder}/deltas/#{f}", @build_directory+f)
		end
	end

end