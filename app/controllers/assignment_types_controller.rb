class AssignmentTypesController < ApplicationController
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
				format.html { redirect_to course_info_path(@course), :flash => {:success => "Assignment type was successfully created."} }
			else
				format.html { render action: "new" }
			end
		end
	end

	def update
		@assignment_type = AssignmentType.find(params[:id])
		@course = Course.find(params[:course_id])

		respond_to do |format|
			if @assignment_type.update_attributes(params[:assignment_type])
				format.html { redirect_to course_info_path(@course), :flash => {:success => "Assignment Type was successfully updated."}}
			else
				format.html { render action: "edit" }
			end
		end
	end

	def destroy
		@course = Course.find(params[:course_id])
		@assignment_type = AssignmentType.find(params[:id])
		@assignment_type.assignments.each do |assignment|
			assignment.destroy
		end
		@assignment_type.destroy

		respond_to do |format|
			format.html { redirect_to course_info_path(@course), :flash => {:success => "Assignment Type was successfully deleted"}}
		end
	end
end