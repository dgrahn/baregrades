class AssignmentsController < ApplicationController
	def index
		@assignments = Assignment.all

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @assignments }
		end
	end

	def show
		@assignment = Assignment.find(params[:id])
		@course = @assignment.course
		@grade = Grade.find_by_assignment_id_and_user_id(@assignment.id, @current_user.id)
		
		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @assignment }
		end
	end

	def new
		@course = Course.find(params[:id])
		@assignment = Assignment.new
		@assignment_types = @course.assignment_types

		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @assignment }
		end
	end

	def edit
		@assignment = Assignment.find(params[:id])
		@course = @assignment.course
		@assignment_types = @course.assignment_types
	end

	def create
		@assignment = Assignment.new(params[:assignment])
		@course = @assignment.course

		respond_to do |format|
			if @assignment.save
				format.html { redirect_to course_path(@course), :flash => {:success => "Assignment was successfully created."}}
			else
				format.html { render action: "new" }
			end
		end
	end

	def update
		@assignment = Assignment.find(params[:id])
		@course = @assignment.course

		respond_to do |format|
			if @assignment.update_attributes(params[:assignment])
				format.html { redirect_to course_path(@course), :flash => {:success => "Assignment was successfully updated."}}
				format.json { head :no_content }
			else
				format.html { render action: "edit" }
				format.json { render json: @assignment.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		@assignment = Assignment.find(params[:id])
		@assignment.destroy

		respond_to do |format|
			format.html { redirect_to assignments_url }
			format.json { head :no_content }
		end
	end
end