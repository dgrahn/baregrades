class ToolsController < ApplicationController
	#Renders the target grade page.
	def target_grade
		@course = Course.find(params[:id])
		@percent_completed = @course.percent_complete(@current_user)
		@grade = @course.user_grade(@current_user)

		if @grade
			@lowest_possible = @percent_completed * @grade
			@highest_possible = @percent_completed * @grade + 100 * (1 - @percent_completed)
		end
	end

	#Renders the grade report.
	def grade_report
		@courses = @current_user.courses
		
		# TODO: Optimize preloading
		ActiveRecord::Associations::Preloader.new(@courses, [:assignment_types]).run
	end

	def gpa_prediction
		@courses = @current_user.courses
	end
	
	#Renders prioritizer page.
	def prioritizer
		courses = @current_user.courses
		
		@remaining = []

		courses.each do |course|
			percentage = course.percent_complete(@current_user)
			
			if percentage != nil
				percentage *= 100
				percentage = percentage.round(2)
				@remaining.push([course.name, percentage])
			end
		end
	end
end