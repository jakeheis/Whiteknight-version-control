#!/usr/bin/env ruby 

require "darkknight/commands/command"
require "darkknight/tree_delta"
require "darkknight/tag"
require "darkknight/build_tree"

class CheckoutCommand < Command

	def help_message
		"Checkout the given commit"
	end

	def execute
		return help if @args.count != 1
		if @args[0] == "HEAD"
			checked_out_commit = Commit.HEAD
		else
			hash = Tag.commit_hash_for_tag(@args[0])
			unless hash
				hash = Commit.expand_hash(@args[0])
			end

			return help unless hash

			checked_out_commit = Commit.new(hash)
		end

		return puts "The working tree must not be dirty." if TreeDelta.dirty_tree?

		builder = BuildTree.new("./", checked_out_commit)
		builder.build

		builder = BuildTree.new(".wk/compare_full/", checked_out_commit)
		builder.build

		
	end

end