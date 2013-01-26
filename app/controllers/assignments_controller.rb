class AssignmentsController < ApplicationController
	before_filter :find_course, 	:only => [:new]
	before_filter :get_variables, 	:only => [:edit, :show, :update, :destroy, :disable, :enable]
	before_filter :check_courses, 	:only => [:new, :show, :edit, :update, :destroy, :disable, :enable]

	def find_course
		@course = Course.find(params[:id])
	end
	
	def get_variables
		@assignment = Assignment.find(params[:id])
		@course = @assignment.course
		@assignment_types = @course.assignment_types
	end
	
	def check_courses
		# Check permissions
		if (not @current_user.is_administrator?) && (not @current_user.courses.include?(@course))
			redirect_to root_path, notice: "Access Denied"
			return
		end
	end
	
	def index
		@assignments = Assignment.all

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @assignments }
		end
	end

	def show
		@grade = Grade.find_by_assignment_id_and_user_id(@assignment.id, @current_user.id)
		
		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @assignment }
		end
	end

	def new
		@assignment = Assignment.new
		@assignment_types = @course.assignment_types

		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @assignment }
		end
	end

	def edit
	end

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

	def update
		respond_to do |format|
			if @assignment.update_attributes(params[:assignment])
				LogsController.updateAssignment(@current_user, @assignment)

				format.html { redirect_to course_path(@course), :flash => {:success => "Assignment was successfully updated."}}
				format.json { head :no_content }
			else
				format.html { render action: "edit" }
				format.json { render json: @assignment.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		LogsController.destroyAssignment(@current_user, @assignment)

		@assignment.destroy

		respond_to do |format|
			format.html { redirect_to assignments_url }
			format.json { head :no_content }
		end
	end
	
	def disable
		
		#@assignment.disabled = true
		
		#respond_to do |format|
		#	if(@assignment.save)
				# format.html { redirect_to course_path(@assignment.course), notice: 'Assignment disabled.' }
			# else
				# format.html { redirect_to course_path(@assignment.course), error: 'Disable failed.' }
			# end
		# end
		
		@assignment_flag = AssignmentFlag.find_by_assignment_id_and_user_id(@assignment.id, @current_user.id)
		
		if(@assignment_flag)
			@assignment_flag.disabled = true
		else
			@assignment_flag = AssignmentFlag.new(:user_id => @current_user.id, :assignment_id => @assignment.id, :disabled => true )
		end
		respond_to do |format|
			if(@assignment_flag.save)
				format.html { redirect_to course_path(@assignment.course), notice: 'Assignment disabled.' }
			else
				format.html { redirect_to course_path(@assignment.course), error: 'Disable failed.' }
			end
		end
	end
	
	def enable
		@assignment_flag = AssignmentFlag.find_by_assignment_id_and_user_id(@assignment.id, @current_user.id)
		
		if(@assignment_flag)
			@assignment_flag.disabled = false
		else
			@assignment_flag = AssignmentFlag.new(:user_id => @current_user.id, :assignment_id => @assignment.id, :disabled => false )
		end
		respond_to do |format|
			if(@assignment_flag.save)
				format.html { redirect_to course_path(@assignment.course), notice: 'Assignment enabled.' }
			else
				format.html { redirect_to course_path(@assignment.course), error: 'Enable failed.' }
			end
		end
	end
end