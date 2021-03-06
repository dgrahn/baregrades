class AssignmentsController < ApplicationController
	include AssignmentsHelper

	before_filter :find_course, 	:only => [:new]
	before_filter :get_variables, 	:only => [:edit, :show, :update, :destroy, :disable, :enable]
	before_filter :check_courses, 	:only => [:new, :show, :edit, :update, :destroy, :disable, :enable]

	#Finds course.
	def find_course
		@course = Course.find(params[:id])
	end
	
	#Gets variables.
	def get_variables
		@assignment = Assignment.find(params[:id])
		@course = @assignment.course
		@assignment_types = @course.assignment_types
	end
	
	
	#Checks current user's permission for the course.
	def check_courses
		# Check permissions
		if (not @current_user.is_administrator?) && (not @current_user.courses.include?(@course))
			redirect_to root_path, notice: "Access Denied"
			return
		end
	end
	
	#Renders assignments index page.
	def index
		@assignments = Assignment.all

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @assignments }
		end
	end

	#Renders show assignments page.
	def show
		@grade = Grade.find_by_assignment_id_and_user_id(@assignment.id, @current_user.id)
		
		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @assignment }
		end
	end

	#Renders new assignment page.
	def new
		@assignment = Assignment.new
		@assignment_types = @course.assignment_types

		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @assignment }
		end
	end

	#Renders edit assignment page.
	def edit
	end
	
	#Creates and saves new assignment
	def create
		@assignment = Assignment.new(params[:assignment])
		@course = @assignment.course
		
		# Check permissions
		if (not @current_user.courses.include?(@course)) && (not @current_user.is_administrator?)
			redirect_to root_path, notice: "Access Denied"
			return
		end
		
		respond_to do |format|
			if @assignment.save
				LogsController.createAssignment(@current_user, @assignment)

				format.html { redirect_to course_path(@course), :flash => {:success => "Assignment was successfully created."}}
			else
				@assignment_types = @course.assignment_types
				format.html { render action: "new" }
			end
		end
	end

	#Updates assignment.
	def update
		@assignment.assign_attributes(params[:assignment])

		respond_to do |format|
			if @assignment.valid?
				LogsController.updateAssignment(@current_user, @assignment)
				@assignment.save
				

				format.html { redirect_to course_path(@course), :flash => {:success => "Assignment was successfully updated."}}
				format.json { head :no_content }
			else
				format.html { render action: "edit" }
				format.json { render json: @assignment.errors, status: :unprocessable_entity }
			end
		end
	end

	#Destroys assignment.
	def destroy
		LogsController.destroyAssignment(@current_user, @assignment)

		@assignment.destroy

		respond_to do |format|
			format.html { redirect_to assignments_url }
			format.json { head :no_content }
		end
	end
	
	#Disables assignment.
	def disable
	
		flagSaved = disableAssignment(@assignment, @current_user)
	
		respond_to do |format|
			if(flagSaved)
				format.html { redirect_to course_path(@assignment.course), notice: 'Assignment disabled' }
			else
				format.html { redirect_to course_path(@assignment.course), error: 'Disable failed' }
			end
		end
	end
	
	#Enables assignment.
	def enable
		flagSaved = enableAssignment(@assignment, @current_user)
		
		respond_to do |format|
			if(flagSaved)
				format.html { redirect_to course_path(@assignment.course), notice: 'Assignment enabled' }
			else
				format.html { redirect_to course_path(@assignment.course), error: 'Enable failed' }
			end
		end
	end
end