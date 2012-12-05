class ToolsController < ApplicationController
	def target_grade
		@course = Course.find(params[:id])
		@percent_completed = @course.percent_complete(@current_user)
		@grade = @course.user_grade(@current_user)

		@lowest_possible = @percent_completed * @grade
		@highest_possible = @percent_completed * @grade + 100 * (1 - @percent_completed)
		
	end
end