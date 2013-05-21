#!/usr/bin/env ruby 

require "darkknight/tree_delta"

class Commit

	attr_reader :hash
	attr_accessor :parent
	attr_accessor :child
	attr_reader :message
	attr_reader :tree_delta
	attr_reader :folder

	def initialize(hash)
		if hash.is_a? String
			@hash = hash
			@folder = ".wk/commits/#{@hash}"

			@parent = File.open("#{@folder}/parent").read if File.exists?("#{@folder}/parent") 
			@child = File.open("#{@folder}/child").read if File.exists?("#{@folder}/child")
				
			if File.exists?("#{@folder}/message")
				@message = File.open("#{@folder}/message").read
			else
				@message = "(No commit message)"
			end

			@tree_delta = JSON.parse(File.open("#{@folder}/tree_delta").read)
		else
			@option_hash = hash
			make_new
		end
	end

	def short_hash
		@hash[0..8]
	end

	# Parent - Child methods
	def make_parent_of(commit)
		commit.parent = self
		self.child = commit
	end

	def child=(commit)
		File.open("#{@folder}/child", "w") {|f| f.write(commit.hash)}
		@child = commit
	end

	def parent=(commit)
		File.open("#{@folder}/parent", "w") {|f| f.write(commit.hash)}
		@parent = commit
	end

	def parent_commit
		return nil if @parent.nil?
		Commit.new(@parent)
	end

	def child_commit
		return nil if @child.nil?
		Commit.new(@child)
	end

	# HEAD methods

	def Commit.HEAD
		return nil unless Commit.has_head?
		head_hash = File.read(".wk/HEAD")
		Commit.new(head_hash)
	end

	def Commit.has_head?
		File.exists?(".wk/HEAD")
	end

	def make_head
		File.open(".wk/HEAD", "w") {|f| f.write(@hash)}
	end

	# Creating new commit

	def Commit.commit(options)
		Commit.new(options)
	end

	def make_new
		@tree_delta = TreeDeltaCommand.delta

		hash_string = Time.new.to_i.to_s + ENV['LOGNAME'] + @tree_delta.to_s
		commit_hash = Digest::SHA2.new << hash_string
		@hash = commit_hash.to_s

		@folder = ".wk/commits/"+@hash
		FileUtils.mkdir_p @folder

		save_new_files
		save_tree_delta
		save_message
		save_file_deltas

		update_head
		update_tracked
	end

	def save_new_files
		FileUtils.mkdir @folder+"/added"
		@tree_delta["Added"].each do |f|
			FileUtils.mkdir_p("#{@folder}/added/#{File.dirname(f)}")
			FileUtils.cp(f, "#{@folder}/added/#{f}")
		end
	end

	def save_tree_delta
		File.open(@folder+"/tree_delta", "w") {|f| f.write(JSON.dump(@tree_delta))}
	end

	def save_message
		if @option_hash["-m"].nil?
			@message = "(No commit message)"
		else
			@message = @option_hash["-m"]
			File.open(@folder+"/message", "w") {|f| f.write(@message)}
		end
	end

	def save_file_deltas
		FileUtils.mkdir @folder+"/deltas"
		@tree_delta["Modified"].each do |f|
			FileUtils.mkdir_p("#{@folder}/deltas/#{File.dirname(f)}")
			old_path = ".wk/last_full/#{f}"
			delta = Diffy::Diff.new(old_path, f, :source => "files", :context => 0, :allow_empty_diff => true, :include_diff_info => true).to_s(:text)
			File.open("#{@folder}/deltas/#{f}", "w") {|f| f.write(delta)}
		end
	end

	def update_head
		old_head = Commit.HEAD
		old_head.make_parent_of(self) unless old_head.nil?
		make_head
	end

	def update_tracked
		currently_tracked = File.read(".wk/tracked_files").split("\n")
		new_tracked = currently_tracked - @tree_delta["Removed"] + @tree_delta["Added"]
		File.open(".wk/tracked_files", "w") {|f| f.write(new_tracked.join("\n"))}
	end

end