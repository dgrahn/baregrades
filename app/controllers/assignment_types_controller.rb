class AssignmentTypesController < ApplicationController
	def index
		@assignment_types = AssignmentType.all

		respond_to do |format|
			format.html
		end
	end

	def show
		@assignment_type = AssignmentType.find(params[:id])
		@course = @assignment_type.course

		respond_to do |format|
			format.html
		end
	end

	def new
		@course = Course.find(params[:course_id])
		@assignment_type = AssignmentType.new

		respond_to do |format|
			format.html
		end
	end

	def edit
		@assignment_type = AssignmentType.find(params[:id])
		@course = Course.find(params[:course_id])
	end

	def create
		@assignment_type = AssignmentType.new(params[:assignment_type])
		@course = Course.find(params[:course_id])
		@assignment_type.course = @course

		respond_to do |format|
			if @assignment_type.save
				format.html { redirect_to course_assignment_type_path(@course, @assignment_type), :flash => {:success => "Assignment type was successfully created."} }
			else
				format.html { render action: "new" }
			end
		end
	end

	def update
		@assignment_type = AssignmentType.find(params[:id])
		@course = @assignment_type.course

		respond_to do |format|
			if @assignment_type.update_attributes(params[:assignment_type])
				format.html { redirect_to course_assignment_type_path(@course, @assignment_type), :flash => {:success => "Assignment Type was successfully updated."}}
			else
				format.html { render action: "edit" }
			end
		end
	end

	def destroy
		@assignment_type = AssignmentType.find(params[:id])
		@assignment_type.destroy

		respond_to do |format|
			format.html { redirect_to assignment_types_url }
		end
	end
end