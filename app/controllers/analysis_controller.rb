class AnalysisController < ApplicationController
	# Renders Analysis index page.
	def index
		@course = Course.find(params[:id])
		
		# Check permissions
		if (not @current_user.is_administrator?) && (not @current_user.courses.include?(@course))
			redirect_to root_path, notice: "Access Denied"
			return
		end
	end

	#Renders the assignment types partial view.
	def assignment_types
		@course = Course.find(params[:id])
		
		respond_to do |format|
			format.json
		end
	end
	
	#Renders the assignments partial view.
	def assignments
		@course = Course.find(params[:id])
		
		respond_to do |format|
			format.json
		end
	end
	
	#Renders the course partial view.
	def course
		@course = Course.find(params[:id])

		respond_to do |format|
			format.json
		end
	end
end