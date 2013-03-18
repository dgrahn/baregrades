class GradesController < ApplicationController
	before_filter :get_variables
	before_filter :check_courses, 	:only => [:create]
	#Gets assignment, assignment_type, and course.
	def get_variables
		@assignment = Assignment.find(params[:assignment_id])
		@assignment_type = @assignment.assignment_type
		@course = @assignment_type.course
	end
	
	#Checks permissions.
	def check_courses
		# Check permissions
		if not @current_user.courses.include?(@course)
			redirect_to root_path, notice: "Access Denied"
			return
		end
	end

	#Renders new grade page.
	def new
		@grade = Grade.new
		
		respond_to do |format|
			# Prevent the user from creating grades for disabled assignments
			if @assignment.isDisabled(@current_user)
				format.html {redirect_to root_path, notice: "Cannot create a grade for a disabled assignment."}
				
			# Users must be in the course to add a grade
			elsif @current_user.courses.include?(@course)
				format.html # new.html.erb
				format.json { render json: @grade }
			else
				format.html {redirect_to root_path, notice: "Access Denied"}
			end
		end
	end

	#Renders edit grade page.
	def edit
		@grade = Grade.find_by_assignment_id_and_user_id(@assignment.id, @current_user.id)
	end
	
	#Creates and saves new grade
	def create
		@grade = Grade.new(params[:grade])
		@grade.assignment_id = params[:assignment_id]
		@grade.user_id = @current_user.id
		
		LogsController.createGrade(@current_user, @grade)

		respond_to do |format|
			# For fast grades (:commit == "Save") redirect to the course page
			if params[:commit] == "Save" && @grade.save
				format.html { redirect_to course_path(@assignment.course), notice: 'Grade was successfully created.' }
			elsif @grade.save
				format.html { redirect_to assignment_path(@assignment), notice: 'Grade was successfully created.' }
			else
				format.html { render action: "new" }
			end
		end
	end
	
	#Edits and saves grade
	def update
		@grade = Grade.find(params[:id])
		
		respond_to do |format|
			# For fast grades (:commit == "Save") redirect to the course page
			if params[:commit] == "Save" && @grade.update_attributes(params[:grade])
				LogsController.updateGrade(@current_user, @grade)

				format.html { redirect_to course_path(@assignment.course), notice: 'Grade was successfully updated.' }
			elsif @grade.update_attributes(params[:grade])
				format.html { redirect_to assignment_path(@assignment), notice: 'Grade was successfully updated.' }
			else
				format.html { render action: "edit" }
			end
		end
	end
	
	#Destroys grade
	def destroy
		# no need to check if current user is the owner of the grade because we find the grade by the current user
		grade = Grade.find_by_assignment_id_and_user_id(params[:assignment_id], @current_user.id)
		assignment = grade.assignment
		grade.destroy
		
		LogsController.destroyGrade(@current_user, grade)

		respond_to do |format|
			if params[:page] == "Course"
				format.html { redirect_to course_path(@assignment.course), notice: 'Grade was successfully destroyed.' }
			else
				format.html { redirect_to assignment_path(@assignment), notice: 'Grade was successfully destroyed.' }
				format.json { head :no_content }
			end
		end
	end
end