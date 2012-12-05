class HomeController < ApplicationController
	def index
		@user = @current_user
		@assignments = @user.assignments.where("due_date")
		@date = params[:month] ? Date.parse(params[:month]) : Date.today
	end

	def privacy
	end
	
	def changeLog
	end
end
