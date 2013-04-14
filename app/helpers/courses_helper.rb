module CoursesHelper
	#Create a Temp calendar file and download it
	def download_course_calendar(course)
		# create a temporary file named after the course name
		require 'date'
		require 'tempfile'
		file = Tempfile.new(["#{course.name} ", ".ics"])
		
		begin
			# Write the calendar to the file
			file.write("BEGIN:VCALENDAR\n");
			file.write("PRODID:-//BareGrades//BareGrades Calendar 1.1//EN\n");
			file.write("VERSION:2.0\n");
			file.write("\n");
			
			# Find all of the assignments in the course
			course.assignments.each do |assignment| 
				# Get the Date of the event
				date = assignment.due_date

				if date.blank?
					date = course.end_date
				end # if
				
				# Change the date format
				date = date.strftime("%Y%m%d")
				
				# Begin the assingmment event
				file.write("BEGIN:VEVENT\n");
				
				file.write("DTSTART;VALUE=DATE:#{date}T000000Z\n"); # Start time
				file.write("DTEND;VALUE=DATE:#{date}T000000Z\n"); # End time
				file.write("SUMMARY;ENCODING=QUOTED-PRINTABLE:#{assignment.name}\n"); # Class identifier
				file.write("DESCRIPTION;ENCODING=QUOTED-PRINTABLE:#{assignment.description}\n"); # course name
			
				# End the assignment event
				file.write("END:VEVENT\n");
				file.write("\n");
			end # each do
		
			file.write("END:VCALENDAR\n");
			
			# Download the file
			send_file(file);
		ensure # forcefully close and delete the file
			file.close
			file.unlink
		end # begin
	end # download_calendar
end