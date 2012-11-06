class AnalysisController < ApplicationController
	def index
		@course = Course.find(params[:course_id])
	end
end