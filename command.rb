#!/usr/bin/env ruby 

class Command

	def initialize(args)
		@args = args
	end

	def go
		if need_help?
			help
		else
			execute
		end
	end

	def need_help?
		@args[0] == "help" || @args[0] == "-h"
	end

	def help
		puts "\n#{self.class.name} Help\n\n#{help_message}\n\n"
	end

	def help_message
		""
	end

	def execute
		# In subclasses something will be done here
	end

end