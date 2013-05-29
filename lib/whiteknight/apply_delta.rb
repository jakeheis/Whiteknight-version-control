#!/usr/bin/env ruby 

class ApplyDelta
	
	def ApplyDelta.apply_delta(delta_path, file_path)
		contents = File.read(file_path)
		delta_contents = File.read(delta_path)

		headers = []
		delta_contents.gsub(/^@@.*@@$/) {|header| headers << header}
		hunks = delta_contents.split(/^@@.*@@$/)
		hunks.shift # Remove first useless hunk

		lines = contents.split("\n")

		offset = 0
		headers.zip(hunks).each do |header, hunk|
			lines.flatten!

			header = DeltaHeader.new(header)

			replace = []

			hunk.split("\n").each do |line|
				replace << line[1..-1] if line[0] == "+" && line != "\\ No newline at end of file"
			end
			
			if header.from_length == 0
				lines.insert(header.from_line+1+offset, replace)
				offset += header.to_length
				next
			end

			if header.to_length == 0
				header.from_length.times {lines.delete_at(header.from_line+offset)}
				offset -= header.from_length
				next
			end

			lines[header.from_line+offset..header.end_from-1+offset] = replace
			offset += header.to_length-header.from_length
		end

		final = lines.join("\n")
		File.open(file_path, "w") {|f| f.write(final)}
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
	end

	def to_s
		return @stripped
	end

end