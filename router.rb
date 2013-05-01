#!/usr/bin/env ruby 

require "./init"
require "./commit"
require "./status"

command_name = nil
command_arg = ARGV[0]

if command_arg == "init"
	command_name = InitCommand
elsif command_arg == "commit"
	command_name = CommitCommand
elsif command_arg == "status"
	command_name = StatusCommand
end

if !command_name
	puts "That command wasn't recgonized"
	exit
end

command = command_name.new(ARGV[1..ARGV.length-1])

command.go