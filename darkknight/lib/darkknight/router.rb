#!/usr/bin/env ruby 

require "darkknight/init"
require "darkknight/commit"
require "darkknight/status"
require "darkknight/diff"
require "darkknight/clean"
require "darkknight/tree_delta"
require "darkknight/tag"
require "darkknight/log"
require "darkknight/checkout"

command_name = nil
command_arg = ARGV[0]

if command_arg == "init"
	command_name = InitCommand
elsif command_arg == "commit" || command_arg == "ci"
	command_name = CommitCommand
elsif command_arg == "status" || command_arg == "st"
	command_name = StatusCommand
elsif command_arg == "diff"
	command_name = DiffCommand
elsif command_arg == "clean"
	command_name = CleanCommand
elsif command_arg == "tag"
	command_name = TagCommand
elsif command_arg == "log" || command_arg == "lg"
	command_name = LogCommand
elsif command_arg == "checkout" || command_arg == "co"
	command_name = CheckoutCommand
elsif command_arg == "delta"
	puts TreeDeltaCommand.delta
	exit
end

if !command_name
	puts "That command wasn't recgonized"
	exit
end

command = command_name.new(ARGV[1..ARGV.length-1])

command.go