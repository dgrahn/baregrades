class AnalysisController < ApplicationController
	def index
		@course = Course.find(params[:id])
		
		# Check permissions
		if (not @current_user.is_administrator?) && (not @current_user.courses.include?(@course))
			redirect_to root_path, notice: "Access Denied"
			return
		end
	end
end