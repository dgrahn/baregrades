class AdminController < ApplicationController
	def index
		@number_of_users = User.count
		@number_of_courses = Course.count
		@number_of_assignments = Assignment.count
		@number_of_grades = Grade.count
		
		@users_per_course = 0

		Course.all.each do |course|
			@users_per_course += course.users.length
		end
		
		@users_per_course = @users_per_course.to_f / @number_of_courses.to_f
	end
end