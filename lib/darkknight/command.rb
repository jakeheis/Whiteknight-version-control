#!/usr/bin/env ruby 

class Command

	def initialize(args)
		@args = args
	end

	def option_handler
		@option_hash = {}

		counter = 0
		while counter < @args.length
			arg = @args[counter]
			if arg.start_with?("-")
				@option_hash[arg] = @args[@args.index(arg)+1]
				counter += 1
			else
				@option_hash[arg] = true
			end
			counter += 1
		end
	end

	def go
		option_handler
		if need_help?
			help
		else
			execute
		end
	end

	def need_help?
		@option_hash.has_key?("-help") || @option_hash.has_key?("-h")
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

	def colorize(text, color_code)
  		"\e[#{color_code}m#{text}\e[0m"
	end

end