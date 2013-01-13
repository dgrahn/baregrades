class AdminController < ApplicationController
	def index
		if not @current_user.is_administrator?
			redirect_to root_path
			return
		end
		
		@number_of_users = User.count
		@number_of_courses = Course.count
		@number_of_assignments = Assignment.count
		@number_of_grades = Grade.count
		
		@users_per_course = 0

		Course.all.each do |course|
			@users_per_course += course.users.length
		end
		
		@users_per_course = @users_per_course.to_f / @number_of_courses.to_f
		
		
		@most_popular_theme = ""
		max_users = 0
		Theme.all.each do |theme|
			if max_users < theme.users.length
				max_users = theme.users.length
				@most_popular_theme = theme.name
			end
		end
		
	end

	def logs
		if not @current_user.is_administrator?
			redirect_to root_path
			return
		end
		
		@logs = Log.limit(params[:number]).all
	end
end