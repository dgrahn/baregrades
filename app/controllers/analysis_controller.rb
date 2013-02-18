class AnalysisController < ApplicationController
	def index
		@course = Course.find(params[:id])
		
		# Check permissions
		if (not @current_user.is_administrator?) && (not @current_user.courses.include?(@course))
			redirect_to root_path, notice: "Access Denied"
			return
		end
	end

	def assignment_types
		@course = Course.find(params[:id])
		
		respond_to do |format|
			format.json
		end
	end

	def assignments
		@course = Course.find(params[:id])
		
		respond_to do |format|
			format.json
		end
	end

	def course
		@course = Course.find(params[:id])

		respond_to do |format|
			format.json
		end
	end
end