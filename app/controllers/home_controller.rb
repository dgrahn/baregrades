class HomeController < ApplicationController
	def index
		@user = @current_user
		@assignments = @user.assignments
		@date = params[:month] ? Date.parse(params[:month]) : Date.today
	end
end
