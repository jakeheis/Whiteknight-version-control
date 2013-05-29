#!/usr/bin/env ruby 

require "whiteknight/commands/command"
require "whiteknight/commit"
require "whiteknight/tag"

class TagCommand < Command

	def help_message
		"Tags the commit with the hash given in the first argument with the tag given in the second argument. Requires two arguments."
	end

	def execute
		return help if @args.count != 2
		return help unless hash = Commit.expand_hash(@args[0])

		Tag.tag(hash, @args[1])
	end

end