namespace :db do
	desc "Add end date to all courses will a null end date"
	task :add_start_end_date => :environment do
		require 'rubygems'
		require 'faker'
		require 'populator'
		puts "Adding end dates"
		Course.all().each do |course|
			if course.start_date.nil?
				course.start_date = Date.new(2013, 1, 3)
			end
			if course.end_date.nil?
				course.end_date = Date.new(2013, 5, 3)
			end
			if not course.save()
				puts "Failed to add start and end date to" + course.name()
				course.errors.full_messages.each do |error|
					puts error
				end
			end
		end
		puts "Added start date" + Date.new(2013, 1, 3).to_s() + " to all courses without a start date."
		puts "Added end date" + Date.new(2013, 5, 3).to_s() + " to all courses without an end date."
	end
end