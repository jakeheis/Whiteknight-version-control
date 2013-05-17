#!/usr/bin/env ruby 

class ApplyDeltaCommmand
	
	def ApplyDeltaCommmand.apply_delta(delta_path, contents)
		delta_contents = File.open(delta_path).read

		headers = []
		delta_contents.gsub(/^@@.*@@$/) {|header| headers << header}
		hunks = delta_contents.split(/^@@.*@@$/)
		hunks.shift # Remove first useless hunk

		lines = contents.split("\n")
		done = false

		offset = 0
		headers.zip(hunks).each do |header, hunk|
			next if done
			puts offset

			# puts "HEAD #{header}"
			# puts "HUNK #{hunk}"
			header = DeltaHeader.new(header)

			replace = []

			hunk.split("\n").each do |line|
				replace << line[1..-1] if line[0] == "+"
			end
			
			# puts "REPLACE #{replace}"

			if header.from_length == 0
				puts "INSERT"
				lines.insert(header.from_line+1, replace)
				offset += header.to_length-header.from_length
				# done = true
				next
			end

			if header.to_length == 0
				puts "DELETE #{header.from_length}"
				header.from_length.times {lines.delete_at(header.from_line+offset)}
				next
			end

			puts "HERE"

			lines[header.from_line..header.end_from-1] = replace
			offset += header.to_length-header.from_length
			# puts "#{header.to_length} arg #{header.from_length}"
			# offset += header.from_length-header.to_length
			# if header.from_length.nil? && header.to_length.nil?
			# 	puts "REPLACEMENT"
			# 	lines[header.from_line.to_i-1] = replace
			# elsif header.from_length.nil?

			# end

			# done = true
		end

		puts "FINAL #{lines}"
		File.open("output", "w") {|f| f.write(lines.join("\n"))}
	end

end

class DeltaHeader

	attr_reader :from_line
	attr_reader :from_length
	attr_reader :end_from

	attr_reader :to_line
	attr_reader :to_length
	attr_reader :end_to

	def initialize(header)
		@stripped = header[3..-3]
		from = @stripped.split(" ")[0]
		from = from[1..-1]
		to = @stripped.split(" ")[1]
		to = to[1..-1]

		from_nums = from.split(",")
		@from_line = from_nums[0].to_i-1
		@from_length = from_nums[1] ? from_nums[1].to_i : 1
		@end_from = @from_line+@from_length

		to_nums = to.split(",")
		@to_line = to_nums[0].to_i-1
		@to_length = to_nums[1] ? to_nums[1].to_i : 1
		@end_to = @to_line+@to_length

		# puts "FROM LINE #{from_line} LENGTH #{from_length} #{from_length.nil?} TO LINE #{to_line} LENGTH #{to_length} #{to_length.nil?}"
	end

	def to_s
		return @stripped
	end

end