#!/usr/bin/env ruby 

class Commit

	attr_reader :hash
	attr_reader :parent
	attr_reader :child
	attr_reader :message
	attr_reader :tree_delta

	def initialize(hash)
		if hash.has_key?(:new)
			
		else
			@hash = hash[:hash]
			folder = ".wk/commits/#{@hash}"

			@parent = File.open("#{folder}/parent").read if File.exists?("#{folder}/parent") 
			@child = File.open("#{folder}/child").read if File.exists?("#{folder}/child")
			
			if File.exists?("#{folder}/message")
				@message = File.open("#{folder}/message").read
			else
				@message = "(No commit message)"
			end

			@tree_delta = JSON.parse(File.open("#{folder}/tree_delta").read)
		end
	end

	def parent_commit
		return nil if @parent.nil?
		Commit.new(:hash => @parent)
	end

	def child_commit
		return nil if @child.nil?
		Commit.new(:hash => @child)
	end

	def short_hash
		@hash[0..8]
	end

	def Commit.HEAD
		head_hash = File.read(".wk/HEAD")
		Commit.new(:hash => head_hash)
	end

	def Commit.has_head?
		File.exists?(".wk/HEAD")
	end

end